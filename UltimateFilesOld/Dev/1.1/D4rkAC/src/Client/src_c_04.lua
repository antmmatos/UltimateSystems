-- Variables
local namesvalue = false
local blipsvalue = false
local linesvalue = false

-- Functions
entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
		local next = true

		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
	local nearbyEntities = {}

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	for k,entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if distance <= maxDistance then
			table.insert(nearbyEntities, isPlayerEntities and k or entity)
		end
	end

	return nearbyEntities
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function lines(newValue)
    linesvalue = newValue
    while linesvalue do
        Citizen.Wait(0)
        local players
        if Config.Framework == "ESX" then
            players = ESX.Game.GetPlayers()
        elseif Config.Framework == "QBCORE" then
            players = QBCore.Functions.GetPlayers()
        end
        for i = 1, #players, 1 do
            if players[i] ~= PlayerId() then
                local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
                local x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(players[i]), true))
                DrawLine(x, y, z, x2, y2, z2, 255, 0, 0, 255)
            end
        end
    end
end

function blips(newValue)
    blipsvalue = newValue
    local blips = {}
    while true do
        if blipsvalue then
            local players
            if Config.Framework == "ESX" then
                players = ESX.Game.GetPlayers()
            elseif Config.Framework == "QBCORE" then
                players = QBCore.Functions.GetPlayers()
            end

            for i = 1, #players, 1 do
                if i ~= PlayerId() then
                    local playerPed = GetPlayerPed(i)

                    RemoveBlip(blips[i])

                    local new_blip = AddBlipForEntity(playerPed)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString(GetPlayerServerId(i) .. " | " .. GetPlayerName(i))
                    EndTextCommandSetBlipName(new_blip)
                    SetBlipColour(new_blip, 59)
                    SetBlipCategory(new_blip, 2)
                    SetBlipScale(new_blip, 0.9)
                    blips[i] = new_blip
                end
            end
        else
            for i = 1, #blips do
                RemoveBlip(blips[i])
            end
        end
        Citizen.Wait(100)
    end
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    local dist = #(GetGameplayCamCoords() - vec(x, y, z))

    local scale = (4.00001 / dist) * 1
    if scale > 0.2 then
        scale = 0.2
    elseif scale < 0.15 then
        scale = 0.15
    end

    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextFont(comicSans and fontId or 4)
        SetTextScale(scale, scale)
        SetTextProportional(true)
        SetTextColour(210, 210, 210, 180)
        SetTextCentre(true)
        SetTextDropshadow(50, 210, 210, 210, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y - 0.025)
    end
end

function ManageHeadLabels(value)
    namesvalue = value
    while namesvalue do
        for _, i in pairs(GetActivePlayers()) do
            if NetworkIsPlayerActive(i) then

                local iPed = GetPlayerPed(i)
                if iPed ~= PlayerPedId() then
                    if DoesEntityExist(iPed) then
                        local headLabelId = CreateMpGamerTag(iPed, " ", 0, 0, " ", 0)
                        SetMpGamerTagName(headLabelId, " ")
                        SetMpGamerTagVisibility(headLabelId, 0, false)
                        RemoveMpGamerTag(headLabelId)

                        DrawText3D(GetEntityCoords(iPed)["x"], GetEntityCoords(iPed)["y"],
                            GetEntityCoords(iPed)["z"] + 1,
                            GetPlayerServerId(i) .. "  |  ~g~" .. GetPlayerName(i) .. "~n~~r~Health~w~: " ..
                                GetEntityHealth(iPed) .. " | ~b~Armor~w~: " .. GetPedArmour(iPed))
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end
