BanListStatus = false
DBLoaded = false
BanList = {}

RegisterServerEvent("UltimateAC:ScriptBan")
AddEventHandler("UltimateAC:ScriptBan", function (numRes, Resources)
    TriggerEvent("UltimateAC:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
        string.format(Locale[Config.Locale]["ResourceStop"], numRes, Resources)), "AntiCheat", nil, string.format(Locale[Config.Locale]["ResourceStop"], numRes, Resources))
end)

RegisterServerEvent("UltimateAC:BanPlayer")
AddEventHandler("UltimateAC:BanPlayer", function(banMessage, admin, target, logBanMessage)
    if not target then
        local _source = source
        local uPlayer = Ultimate.GetPlayerFromId(tonumber(_source))
        if not uPlayer then return end
        if not uPlayer.isAdmin() then
            local screenshot = TriggerClientCallback {
                source = _source,
                eventName = 'UltimateAC:RequestScreenshot'
            }
            uPlayer.ban(_source, banMessage, admin, logBanMessage, screenshot)
        end
    else
        local uPlayer = Ultimate.GetPlayerFromId(tonumber(target))
        local _target = target
        if tonumber(admin) then
            admin = GetPlayerName(admin)
        end
        if not uPlayer then return end
        if not uPlayer.isAdmin() then
            local screenshot = TriggerClientCallback {
                source = _target,
                eventName = 'UltimateAC:RequestScreenshot'
            }
            uPlayer.ban(_target, banMessage, admin, logBanMessage, screenshot)
        end
    end
end)

RegisterServerEvent("UltimateAC:ManualBanPlayer")
AddEventHandler("UltimateAC:ManualBanPlayer", function(banMessage, adminid, target)
    local uPlayer = Ultimate.GetPlayerFromId(tonumber(target))
    if not uPlayer.isAdmin() then
        local logBanMessage = string.format(banMessage, GetPlayerName(adminid))
        banMessage = string.format(banMessage, GetPlayerName(adminid))
        local screenshot = TriggerClientCallback {
            source = target,
            eventName = 'UltimateAC:RequestScreenshot'
        }
        uPlayer.ban(target, banMessage, GetPlayerName(adminid), logBanMessage, screenshot, true)
    end
end)

ValidWeapons = {}
RegisterServerEvent('UltimateAC:AddWeapon', function(player, weaponhash)
    local player = tonumber(player)
    local playerNet = NetworkGetEntityFromNetworkId(player)
    local playerSource = NetworkGetFirstEntityOwner(playerNet)
    local _src = tonumber(playerSource)
    local hashWeapon = tonumber(weaponhash)
    if inTable(weaponsHashNotInclude, hashWeapon) then
        return
    end
    if ValidWeapons[_src] == nil then
        ValidWeapons[_src] = {}
    end
    if not inTable(ValidWeapons[_src], hashWeapon) then
        table.insert(ValidWeapons[_src], hashWeapon)
    end
end)

RegisterServerEvent('UltimateAC:ClearWeapons', function(player)
    local player = tonumber(player)
    local playerNet = NetworkGetEntityFromNetworkId(player)
    local playerSource = NetworkGetFirstEntityOwner(playerNet)
    local _src = tonumber(playerSource)
    ValidWeapons[_src] = {}
end)

RegisterServerEvent('UltimateAC:RemoveWeapon', function(player, weaponhash)
    local player = tonumber(player)
    local playerNet = NetworkGetEntityFromNetworkId(player)
    local playerSource = NetworkGetFirstEntityOwner(playerNet)
    local _src = tonumber(playerSource)
    local hashWeapon = tonumber(weaponhash)
    if hashWeapon == nil then
        return
    end
    if ValidWeapons[_src] == nil then
        ValidWeapons[_src] = {}
    end
    for i, v in ipairs(ValidWeapons[_src]) do
        if v == hashWeapon then
            table.remove(ValidWeapons[_src], i)
        end
    end
end)

RegisterServerEvent('UltimateAC:VerifyWeapon', function(listWeapons)
    local _src = tonumber(source)
    if ValidWeapons[_src] == nil then
        ValidWeapons[_src] = {}
        return
    end
    if listWeapons == nil then
        return
    end
    local valid = TableCompare(ValidWeapons[_src], listWeapons)
    if not valid then
        TriggerEvent("UltimateAC:BanPlayer",
            string.format(Locale[Config.Locale]["BanMessage"], Locale[Config.Locale]["WeaponSpawning"]), "AntiCheat",
            _src, Locale[Config.Locale]["WeaponSpawning"])
    end
end)

RegisterNetEvent('UltimateAC:ClearVehicles', function()
	local _src = tonumber(source)
	local coords = GetEntityCoords(GetPlayerPed(_src))
	for _, v in pairs(GetAllVehicles()) do
		local objCoords = GetEntityCoords(v)
		local dist = #(coords - objCoords)
		if dist < 2000 then
			if DoesEntityExist(v) then
				DeleteEntity(v)
			end
		end
	end
end)

RegisterNetEvent('UltimateAC:ClearPeds', function()
	local _src = tonumber(source)
	local coords = GetEntityCoords(GetPlayerPed(_src))
	for _, v in pairs(GetAllPeds()) do
		local objCoords = GetEntityCoords(v)
		local dist = #(coords - objCoords)
		if dist < 2000 then
			if DoesEntityExist(v) then
				DeleteEntity(v)
			end
		end
	end
end)

RegisterNetEvent('UltimateAC:ClearObjects', function()
	local _src = tonumber(source)
	local coords = GetEntityCoords(GetPlayerPed(_src))
	for _, v in pairs(GetAllObjects()) do
		local objCoords = GetEntityCoords(v)
		local dist = #(coords - objCoords)
		if dist < 2000 then
			if DoesEntityExist(v) then
				DeleteEntity(v)
			end
		end
	end
end)

RegisterCommand("ultimatereload", function(source, args, rawCommand)
    if Validated then
        local _source = source
        if _source == 0 then
            LoadBans()
            print(" ^7|| ^1[UltimateAC] ^7|| ^2BanList reloaded!")
        else
            local uPlayer = Ultimate.GetPlayerFromId(tonumber(_source))
            if uPlayer.isAdmin() then
                LoadBans()
                print(" ^7|| ^1[UltimateAC] ^7|| ^2BanList reloaded!")
            end
        end
    end
end)

RegisterCommand("ultimateunban", function(source, args, rawCommand)
    if Validated then
        local _source = source
        if args[1] ~= nil then
            local isBanned
            if Config.MySQLSystem == "mysql-async" then
                isBanned = MySQL.Sync.fetchAll(
                    "SELECT COUNT(*) AS 'Exists' FROM ultimateac WHERE SteamID = @data OR License = @data OR DiscordID = @data",
                    {
                        ["@data"] = args[1]
                    })
            elseif Config.MySQLSystem == "oxmysql" then
                isBanned = MySQL.query.await(
                    "SELECT COUNT(*) AS 'Exists' FROM ultimateac WHERE SteamID = ? OR License = ? OR DiscordID = ?",
                    {args[1]})
            end
            if tonumber(isBanned[1].Exists) > 0 then
                if _source ~= 0 then
                    local uPlayer = Ultimate.GetPlayerFromId(tonumber(_source))
                    if uPlayer.isAdmin() then
                        UnbanFunction(args, _source)
                    end
                else
                    UnbanFunction(args, _source)
                end
            else
                if _source == 0 then
                    print(" ^7|| ^1[UltimateAC] ^7|| ^2Player not found!")
                else
                    Ultimate.ShowNotification(_source, "Player not found!")
                end
            end
        else
            if _source == 0 then
                print(" ^7|| ^1[UltimateAC] ^7|| ^2Invalid syntax!")
            else
                Ultimate.ShowNotification(_source, "Invalid syntax!")
            end
        end
    end
end)

function UnbanFunction(args, source)
    if string.sub(tostring(args[1]), 1, string.len("license:")) == "license:" then
        MySQL.Async.execute('DELETE FROM `UltimateAC` WHERE License = @License', {
            ["@License"] = tostring(args[1])
        }, function(identifiers)
        end)
    elseif string.sub(tostring(args[1]), 1, string.len("discord:")) == "discord:" then
        MySQL.Async.execute('DELETE FROM `UltimateAC` WHERE DiscordID = @DiscordID', {
            ["@DiscordID"] = tostring(args[1])
        }, function(identifiers)
        end)
    elseif string.sub(tostring(args[1]), 1, string.len("steam:")) == "steam:" then
        MySQL.Async.execute('DELETE FROM `UltimateAC` WHERE SteamID = @SteamID', {
            ["@SteamID"] = tostring(args[1])
        }, function(identifiers)
        end)
    end
    if Ultimate.isSourceZero(source) then
        print(" ^7|| ^1[UltimateAC] ^7|| ^2Player unbanned!")
    else
        Ultimate.ShowNotification(source, "Player unbanned!")
    end
    LoadBans()
end

CreateThread(function()
    while true do
        if Validated then
            if BanListStatus == false then
                LoadBans()
                if BanList ~= {} then
                    BanListStatus = true
                end
            end
            Wait(10000)
        end
        Citizen.Wait(0)
    end
end)

CreateThread(function()
    while true do
        if Validated then
            if DBLoaded then
                Citizen.Wait(tonumber(Config.BanReload) * 1000)
                LoadBans()
                print(" ^7|| ^1[UltimateAC] ^7|| ^2BanList reloaded! ^7")
            end
            Citizen.Wait(0)
        end
        Citizen.Wait(0)
    end
end)

function LoadBans()
    while not DatabaseLoaded do
        Citizen.Wait(100)
    end
    while not Validated do
        Citizen.Wait(100)
    end
    MySQL.Async.fetchAll('SELECT * FROM UltimateAC', {}, function(identifiers)
        BanList = {}
        for i = 1, #identifiers, 1 do
            table.insert(BanList, {
                License = identifiers[i].License,
                SteamID = identifiers[i].SteamID,
                PlayerIP = identifiers[i].PlayerIP,
                DiscordID = identifiers[i].DiscordID,
                PlayerName = identifiers[i].PlayerName,
                Date = identifiers[i].Date,
                Reason = identifiers[i].Reason,
                Admin = identifiers[i].Admin,
                isManual = identifiers[i].isManual
            })
        end
    end)
end

MySQL.ready(function()
    while not Validated do
        Citizen.Wait(100)
    end
    if Validated then
        DBLoaded = true
        LoadBans()
    end
end)

function onPlayerConnecting(playerName, setKickReason, deferrals)
    if Validated then
        local _source = source
        --print(" ^7|| ^1[UltimateAC] ^7|| Player ^2" .. playerName .. "^7 is connecting")
        --print(" ^7|| ^1[UltimateAC] ^7|| Checking if ^2" .. playerName .. "^7 is banned")
        deferrals.defer()
        Wait(0)
        deferrals.update(string.format("Hello %s. Your Steam ID is being checked...", playerName))
        local License = nil
        local PlayerIP = nil
        local DiscordID = nil
        local PlayerName = playerName
        local SteamID = nil

        for k, v in pairs(GetPlayerIdentifiers(_source)) do
            if string.sub(v, 1, string.len("license:")) == "license:" then
                License = v
            elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
                PlayerIP = v
            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                DiscordID = v
            elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
                SteamID = v
            end
        end
        Wait(1500)
        if SteamID == nil then
            if Config.RequireSteam then
                setKickReason('\n🛡️ || UltimateAC || 🛡️\n' .. Locale[Config.Locale]["SteamNotFound"])
                print(" ^7|| ^1[UltimateAC] ^7|| ^1" .. PlayerName .. "^7 tried to connect but couldn't find SteamID!")
                CancelEvent()
                return
            end
        end

        if PlayerIP == nil then
            PlayerIP = GetPlayerEndpoint(source)
            if PlayerIP == nil then
                PlayerIP = 'IP NOT FOUND'
            end
        end
        if DiscordID == nil then
            DiscordID = 'DISCORD NOT FOUND'
        end

        if (BanList == {}) then
            Citizen.Wait(1000)
        end

        for i = 1, #BanList, 1 do
            if (tostring(BanList[i].License)) == tostring(License) or (tostring(BanList[i].PlayerIP)) ==
                tostring(PlayerIP) or (tostring(BanList[i].DiscordID)) == tostring(DiscordID) or
                (tostring(BanList[i].SteamID)) == tostring(SteamID) then
                if BanList[i].isManual then
                    deferrals.done('\n🛡️ || UltimateAC || 🛡️\n' .. Locale[Config.Locale]["BanPermanently"] ..
                                       "\n" .. BanList[i].Reason)
                else
                    deferrals.done('\n🛡️ || UltimateAC || 🛡️\n' .. BanList[i].Reason)
                end
                print(' ^7|| ^1[UltimateAC] ^7|| ^1' .. PlayerName .. '^7 tried to connect but is banned!')
            end
        end
        deferrals.done()
    end
end

AddEventHandler('playerConnecting', onPlayerConnecting)
