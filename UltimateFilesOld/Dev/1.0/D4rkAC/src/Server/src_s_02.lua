BanListStatus = false
DBLoaded = false

RegisterServerEvent("d4rkac:BanPlayer")
AddEventHandler("d4rkac:BanPlayer", function(banMessage, admin, target, logBanMessage)
    if not target then
        local _source = source
        if not IsPlayerAceAllowed(_source, ConfigServer.AcePermission) then
            TriggerClientEvent("d4rkac:ScreenshotRequest", _source, _source, banMessage, admin, logBanMessage)
        end
    else
        local _target = target
        if not IsPlayerAceAllowed(_target, ConfigServer.AcePermission) then 
            TriggerClientEvent("d4rkac:ScreenshotRequest", _target, _target, banMessage, admin, logBanMessage)
        end
    end
end)

RegisterNetEvent("d4rkac:BanPlayerScreenshot")
AddEventHandler("d4rkac:BanPlayerScreenshot", function(_source, banMessage, admin, logBanMessage, link)
    BanPlayer(_source, banMessage, admin, logBanMessage, link)
end)

RegisterCommand("d4rkacreload", function(source, args, rawCommand)
    local _source = source
    if _source == 0 then
        LoadBans()
        print(" ^7| ^1[D4rkAC] ^7| ^2BanList reloaded!")
    else
        if IsPlayerAceAllowed(_source, ConfigServer.AcePermission) then
            LoadBans()
            print(" ^7| ^1[D4rkAC] ^7| ^2BanList reloaded!")
        end
    end
end)

RegisterCommand("d4rkacunban", function(source, args, rawCommand)
    local _source = source
    if args[1] ~= nil then
        if _source ~= 0 then
            if IsPlayerAceAllowed(_source, ConfigServer.AcePermission) then
                if string.sub(tostring(args[1]), 1, string.len("license:")) == "license:" then
                    MySQL.Async.execute('DELETE FROM `D4rkAC` WHERE License = @License', {
                        ["@License"] = tostring(args[1])
                    }, function(identifiers)
                    end)
                elseif string.sub(tostring(args[1]), 1, string.len("discord:")) == "discord:" then
                    MySQL.Async.execute('DELETE FROM `D4rkAC` WHERE DiscordID = @DiscordID', {
                        ["@DiscordID"] = tostring(args[1])
                    }, function(identifiers)
                    end)
                elseif string.sub(tostring(args[1]), 1, string.len("steam:")) == "steam:" then
                    MySQL.Async.execute('DELETE FROM `D4rkAC` WHERE SteamID = @SteamID', {
                        ["@SteamID"] = tostring(args[1])
                    }, function(identifiers)
                    end)
                end
            end
        else
            if string.sub(tostring(args[1]), 1, string.len("license:")) == "license:" then
                MySQL.Async.execute('DELETE FROM `D4rkAC` WHERE License = @License', {
                    ["@License"] = tostring(args[1])
                }, function(identifiers)
                end)
            elseif string.sub(tostring(args[1]), 1, string.len("discord:")) == "discord:" then
                MySQL.Async.execute('DELETE FROM `D4rkAC` WHERE DiscordID = @DiscordID', {
                    ["@DiscordID"] = tostring(args[1])
                }, function(identifiers)
                end)
            elseif string.sub(tostring(args[1]), 1, string.len("steam:")) == "steam:" then
                MySQL.Async.execute('DELETE FROM `D4rkAC` WHERE SteamID = @SteamID', {
                    ["@SteamID"] = tostring(args[1])
                }, function(identifiers)
                end)
            end
        end
    end
end)

CreateThread(function()
    while true do
        if BanListStatus == false then
            LoadBans()
            if BanList ~= {} then
                BanListStatus = true
            end
        end
        Wait(10000)
    end
end)

CreateThread(function()
    while true do
        if DBLoaded then
            Citizen.Wait(tonumber(ConfigServer.BanReload) * 1000)
            LoadBans()
            print(" ^7| ^1[D4rkAC] ^7| ^2BanList reloaded! ^7")
        end
        Citizen.Wait(0)
    end
end)

function LoadBans()
    MySQL.Async.fetchAll('SELECT * FROM D4rkAC', {}, function(identifiers)
        BanList = {}
        if Validated then
            for i = 1, #identifiers, 1 do
                table.insert(BanList, {
                    License = identifiers[i].License,
                    SteamID = identifiers[i].SteamID,
                    PlayerIP = identifiers[i].PlayerIP,
                    DiscordID = identifiers[i].DiscordID,
                    PlayerName = identifiers[i].PlayerName,
                    Date = identifiers[i].Date,
                    Reason = identifiers[i].Reason,
                    Admin = identifiers[i].Admin
                })
            end
        end
    end)
end

MySQL.ready(function()
    DBLoaded = true
    LoadBans()
end)

function BanPlayer(target, banMessage, admin, logBanMessage, link)
    if admin == nil then
        admin = "AntiCheat"
    end
    -- local data = Split(banMessage, "string")
    local License = nil
    local PlayerIP = nil
    local DiscordID = nil
    local PlayerName = GetPlayerName(target)
    local SteamID = nil
    local date = os.date("%Y/%m/%d %H:%M")

    for k, v in pairs(GetPlayerIdentifiers(target)) do
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

    if PlayerIP == nil then
        PlayerIP = GetPlayerEndpoint(target)
        if PlayerIP == nil then
            PlayerIP = 'IP NOT FOUND'
        end
    end
    if DiscordID == nil then
        DiscordID = 'DISCORD NOT FOUND'
    end
    LogToDiscordBan(target,
        "**Player Name:** " .. PlayerName .. "\n**ServerID:** " .. target .. "\n**SteamID:** " .. SteamID ..
            "\n**License:** " .. License .. "\n**DiscordID:** " .. DiscordID .. "\n**Discord Tag:** <@" ..
            DiscordID:gsub("discord:", "") .. ">\n**IP:** " .. PlayerIP:gsub("ip:", "") .. "\n**Reason:** " ..
            logBanMessage, link)

    TriggerClientEvent("d4rkac:crashPlayer", target)

    MySQL.Async.execute(
        'INSERT INTO D4rkAC (PlayerName, SteamID, License, DiscordID, PlayerIP, Date, Reason, Admin, Screenshot) VALUES (@PlayerName, @SteamID, @License, @DiscordID, @PlayerIP, @Date, @Reason, @Admin, @Screenshot)',
        {
            ['@PlayerName'] = PlayerName,
            ['@SteamID'] = SteamID,
            ['@License'] = License,
            ['@DiscordID'] = DiscordID,
            ['@PlayerIP'] = PlayerIP,
            ['@Date'] = date,
            ['@Reason'] = banMessage,
            ['@Admin'] = admin,
            ['@Screenshot'] = link
        }, function()
        end
    )
    LoadBans()
end

AddEventHandler('playerConnecting', function(playerName, setKickReason)

    print(" ^7| ^1[D4rkAC] ^7| Player ^2" .. playerName .. "^7 is connecting")
    print(" ^7| ^1[D4rkAC] ^7| Checking if ^2" .. playerName .. "^7 is banned")
    local License = nil
    local PlayerIP = nil
    local DiscordID = nil
    local PlayerName = playerName
    local SteamID = nil

    for k, v in pairs(GetPlayerIdentifiers(source)) do
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

    if SteamID == nil then
        if ConfigServer.RequireSteam then
            setKickReason('\n🛡️ | D4rkAC | 🛡️\n' .. Locale[ConfigServer.Locale]["SteamNotFound"])
            print(" ^7| ^1[D4rkAC] ^7| ^1' .. PlayerName .. '^7 tried to connect but couldn't find SteamID!")
            CancelEvent()
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
        if (tostring(BanList[i].License)) == tostring(License) or (tostring(BanList[i].PlayerIP)) == tostring(PlayerIP) or
            (tostring(BanList[i].DiscordID)) == tostring(DiscordID) or (tostring(BanList[i].SteamID)) ==
            tostring(SteamID) then
            setKickReason('\n🛡️ | D4rkAC | 🛡️\n' .. BanList[i].Reason)
            print(' ^7| ^1[D4rkAC] ^7| ^1' .. PlayerName .. '^7 tried to connect but is banned!')
            CancelEvent()
        end
    end
end)
