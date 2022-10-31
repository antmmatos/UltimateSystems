-- Variables
local namesvalue = false
local blipsvalue = false
local linesvalue = false

-- Functions
function lines(newValue)
    linesvalue = newValue
    while linesvalue do
        Citizen.Wait(0)
        local players = GetActivePlayers()
        for i = 1, #players, 1 do
            if players[i] ~= PlayerId() then
                local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
                local x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(players[i]), true))
                DrawLine(x, y, z, x2, y2, z2, 123, 26, 249, 255)
            end
        end
    end
end

function table.removekey(array, element)
	for i = 1, #array do
		if array[i] == element then
			table.remove(array, i)
		end
	end
end

function blips(newValue)
    blipsvalue = newValue
    if not blipsvalue then
        for i = 1, #pblips do
            RemoveBlip(pblips[i])
        end
    else
        Citizen.CreateThread(function()
            pblips = {}
            while blipsvalue do
                local plist = GetActivePlayers()
                table.removekey(plist, PlayerId())
                for i = 1, #plist do
                    if NetworkIsPlayerActive(plist[i]) then
                        ped = GetPlayerPed(plist[i])
                        pblips[i] = GetBlipFromEntity(ped)
                        if not DoesBlipExist(pblips[i]) then
                            pblips[i] = AddBlipForEntity(ped)
                            SetBlipSprite(pblips[i], 1)
                            Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], true)
                        else
                            veh = GetVehiclePedIsIn(ped, false)
                            blipSprite = GetBlipSprite(pblips[i])
                            if not GetEntityHealth(ped) then
                                if blipSprite ~= 274 then
                                    SetBlipSprite(pblips[i], 274)
                                    Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], false)
                                end
                            elseif veh then
                                vehClass = GetVehicleClass(veh)
                                vehModel = GetEntityModel(veh)
                                if vehClass == 15 then
                                    if blipSprite ~= 422 then
                                        SetBlipSprite(pblips[i], 422)
                                        Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], false)
                                    end
                                elseif vehClass == 16 then
                                    if vehModel == GetHashKey("besra") or vehModel == GetHashKey("hydra") or vehModel ==
                                        GetHashKey("lazer") then -- jet
                                        if blipSprite ~= 424 then
                                            SetBlipSprite(pblips[i], 424)
                                            Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], false)
                                        end
                                    elseif blipSprite ~= 423 then
                                        SetBlipSprite(pblips[i], 423)
                                        Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], false)
                                    end
                                elseif vehClass == 14 then
                                    if blipSprite ~= 427 then
                                        SetBlipSprite(pblips[i], 427)
                                        Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], false)
                                    end
                                elseif vehModel == GetHashKey("insurgent") or vehModel == GetHashKey("insurgent2") or
                                    vehModel == GetHashKey("limo2") then
                                    if blipSprite ~= 426 then
                                        SetBlipSprite(pblips[i], 426)
                                        Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], false)
                                    end
                                elseif vehModel == GetHashKey("rhino") then
                                    if blipSprite ~= 421 then
                                        SetBlipSprite(pblips[i], 421)
                                        Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], false)
                                    end
                                elseif blipSprite ~= 1 then
                                    SetBlipSprite(pblips[i], 1)
                                    Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], true)
                                end
                                passengers = GetVehicleNumberOfPassengers(veh)
                                if passengers then
                                    if not IsVehicleSeatFree(veh, -1) then
                                        passengers = passengers + 1
                                    end
                                    ShowNumberOnBlip(pblips[i], passengers)
                                else
                                    HideNumberOnBlip(pblips[i])
                                end
                            else
                                HideNumberOnBlip(pblips[i])
                                if blipSprite ~= 1 then
                                    SetBlipSprite(pblips[i], 1)
                                    Citizen.InvokeNative(0x5FBCA48327B914DF, pblips[i], true)
                                end
                            end
                            SetBlipRotation(pblips[i], math.ceil(GetEntityHeading(veh)))
                            SetBlipNameToPlayerName(pblips[i], plist[i])
                            SetBlipScale(pblips[i], 0.85)
                            if IsPauseMenuActive() then
                                SetBlipAlpha(pblips[i], 255)
                            else
                                x1, y1 = table.unpack(GetEntityCoords(PlayerPedId()))
                                x2, y2 = table.unpack(GetEntityCoords(GetPlayerPed(plist[i])))
                                distance = (math.floor(
                                    math.abs(math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))) / -1)) + 900
                                if distance < 0 then
                                    distance = 0
                                elseif distance > 255 then
                                    distance = 255
                                end
                                SetBlipAlpha(pblips[i], distance)
                            end
                        end
                    end
                end
                Wait(0)
            end
        end)
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
                if DoesEntityExist(iPed) then
                    local headLabelId = CreateMpGamerTag(iPed, " ", 0, 0, " ", 0)
                    SetMpGamerTagName(headLabelId, " ")
                    SetMpGamerTagVisibility(headLabelId, 0, false)
                    RemoveMpGamerTag(headLabelId)

                    DrawText3D(GetEntityCoords(iPed)["x"], GetEntityCoords(iPed)["y"],
                        GetEntityCoords(iPed)["z"] + 1,
                        "~y~"..GetPlayerServerId(i) .. "  |  ~g~" .. GetPlayerName(i) .. "~n~~r~Health~w~: " ..
                            GetEntityHealth(iPed) .. " | ~b~Armor~w~: " .. GetPedArmour(iPed))
                end
            end
        end
        Citizen.Wait(0)
    end
end
