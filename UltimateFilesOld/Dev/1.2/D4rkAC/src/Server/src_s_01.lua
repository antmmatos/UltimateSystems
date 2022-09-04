ESX = nil
QBCore = nil
Validated = false
turnoff = os.exit
local names = {}
local BlacklistedObjectsList = {}
local WhitelistedObjectsList = {}
local entitiesSpawned = {}
local vehiclesSpawned = {}
local pedsSpawned = {}

if ConfigServer.Framework == "ESX" then
    TriggerEvent(ConfigServer.ESX, function(obj)
        ESX = obj
    end)
elseif ConfigServer.Framework == "QBCORE" then
    QBCore = exports['qb-core']:GetCoreObject()
end

for k,v in ipairs(ConfigServer.PermissionGroups) do
    ExecuteCommand("add_ace group." .. v .. " " .. ConfigServer.AcePermission .. " allow")
end

function LogToDiscordLicense(license, finishDate, owner, lifetime)
    local logembed
    if lifetime then
        logembed = {{
            color = "15536915",
            title = "**D4rkAntiCheat**",
            description = "```License Authenticated!\nOwner: " .. owner .. "\nLicense Type: Lifetime\nLicense: " ..
                license .. "```",
            footer = {
                text = "D4rkAC - " .. D4rkAC.Version .. " | " .. os.date("%Y/%m/%d %X")
            }
        }}
    else
        logembed = {{
            color = "15536915",
            title = "**D4rkAntiCheat**",
            description = "```License Authenticated!\nOwner: " .. owner .. "\nLicense Type: Subscription\nDays left: " ..
                finishDate .. "\nLicense: " .. license .. "```",
            footer = {
                text = "D4rkAC - " .. D4rkAC.Version .. " | " .. os.date("%Y/%m/%d %X")
            }
        }}
    end
    PerformHttpRequest(ConfigServer.WebhookLicense, function(err, text, headers)
    end, 'POST', json.encode({
        username = "D4rkAC | License Logs",
        embeds = logembed
    }), {
        ['Content-Type'] = 'application/json'
    })
    PerformHttpRequest(ConfigServer.WebhookGeneral, function(err, text, headers)
    end, 'POST', json.encode({
        username = "D4rkAC | License Logs",
        embeds = logembed
    }), {
        ['Content-Type'] = 'application/json'
    })
end

PerformHttpRequest("http://51.255.174.195:1589/index.php", function(arg, request)
    if request == nil or request == "" then
        print("----------------------------------------------------------------")
        print("^7| ^1[D4rkAC] ^7| ^4Version: " .. D4rkAC.Version .. "^7")
        print("^7| ^1[D4rkAC] ^7| ^1Authentication Error!^7")
        print("----------------------------------------------------------------")
        Citizen.Wait(3000)
        StopResource(GetCurrentResourceName())
        turnoff()
    end

    if request == "InvalidIP" then
        print("----------------------------------------------------------------")
        print("^7| ^1[D4rkAC] ^7| ^4Version: " .. D4rkAC.Version .. "^7")
        print("^7| ^1[D4rkAC] ^7| ^1Invalid IP!^7")
        print("^7| ^1[D4rkAC] ^7| ^1Server turning off in 5 seconds...^7")
        print("----------------------------------------------------------------")
        Citizen.Wait(5000)
        StopResource(GetCurrentResourceName())
        turnoff()
    elseif request == "ExpiredLicense" then
        print("----------------------------------------------------------------")
        print("^7| ^1[D4rkAC] ^7| ^4Version: " .. D4rkAC.Version .. "^7")
        print("^7| ^1[D4rkAC] ^7| ^1License Expired!^7")
        print("^7| ^1[D4rkAC] ^7| ^1Server turning off in 5 seconds...^7")
        print("----------------------------------------------------------------")
        Citizen.Wait(5000)
        StopResource(GetCurrentResourceName())
        turnoff()
    elseif request == "InvalidLicense" then
        print("----------------------------------------------------------------")
        print("^7| ^1[D4rkAC] ^7| ^4Version: " .. D4rkAC.Version .. "^7")
        print("^7| ^1[D4rkAC] ^7| ^1License Invalid!^7")
        print("^7| ^1[D4rkAC] ^7| ^1Server turning off in 5 seconds...^7")
        print("----------------------------------------------------------------")
        Citizen.Wait(5000)
        StopResource(GetCurrentResourceName())
        turnoff()
    elseif request == "Manutencao" then
        print("----------------------------------------------------------------")
        print("^7| ^1[D4rkAC] ^7| ^4Version: " .. D4rkAC.Version .. "^7")
        print("^7| ^1[D4rkAC] ^7| ^1AntiCheat Servers are in Maintenance!^7")
        print("^7| ^1[D4rkAC] ^7| ^1Server turning off in 5 seconds...^7")
        print("----------------------------------------------------------------")
        Citizen.Wait(5000)
        StopResource(GetCurrentResourceName())
        turnoff()
    else
        local framework = "Custom/Unknown"
        local data = Split(request, " | ")
        local es_extended = GetResourceState("es_extended")
        local qbcore = GetResourceState("qb-core")
        if qbcore == "started" then
            print("----------------------------------------------------------------")
            print("^7| ^1[D4rkAC] ^7| ^4Version: " .. D4rkAC.Version .. "^7")
            print("^7| ^1[D4rkAC] ^7| ^1QBCore Support is still in BETA!^7")
            print("^7| ^1[D4rkAC] ^7| ^1Any problems you get, report to the Owner^7")
            print("----------------------------------------------------------------")
        end
        if es_extended == "started" then
            framework = "ESX"
        end
        if framework == "Custom/Unknown" then
            print("----------------------------------------------------------------")
            print("^7| ^1[D4rkAC] ^7| ^4Version: " .. D4rkAC.Version .. "^7")
            print("^7| ^1[D4rkAC] ^7| ^1The AntiCheat require an ESX Server or QBCore Server to run!^7")
            print("^7| ^1[D4rkAC] ^7| ^1Server turning off in 5 seconds...^7")
            print("----------------------------------------------------------------")
            Citizen.Wait(5000)
            turnoff()
        end
        print("----------------------------------------------------------------")
        print("^7| ^1[D4rkAC] ^7| ^7Version: ^1" .. D4rkAC.Version .. "^7")
        print("^7| ^1[D4rkAC] ^7| ^2License Authorized!^7")
        print("")
        print("^7| ^1[D4rkAC] ^7| ^7Welcome back, ^1" .. data[1] .. "^7!")
        if string.find(request, "LIFETIME") then
            print("^7| ^1[D4rkAC] ^7| Time left: ^1Lifetime.^7")
            LogToDiscordLicense(D4rkAC.License, "Lifetime", data[1], true)
        else
            if tonumber(data[2]) > 1 then
                print("^7| ^1[D4rkAC] ^7| Time left: ^1" .. data[2] .. " ^7days.")
                LogToDiscordLicense(D4rkAC.License, data[2], data[1], false)
            else
                print("^7| ^1[D4rkAC] ^7| Time left: ^1" .. data[2] .. " ^7day.")
                LogToDiscordLicense(D4rkAC.License, data[2], data[1], false)
            end
        end
        print("")
        print("^7| ^1[D4rkAC] ^7| ^7Framework Detected: ^1" .. framework .. "^7")
        print("^7| ^1[D4rkAC] ^7| ^7License: ^1" .. D4rkAC.License .. "^7")
        print("----------------------------------------------------------------")
        Validated = true
        if tonumber(data[3]) ~= tonumber(D4rkAC.Version) then
            print("\n----------------------------------------------------------------")
            print("^7| ^1[D4rkAC] ^7| ^4Version: " .. D4rkAC.Version .. "^7")
            print("^7| ^1[D4rkAC] ^7| ^4New version: " .. data[3] .. "^7")
            print("^7| ^1[D4rkAC] ^7| ^1Update it to get new features!^7")
            print("----------------------------------------------------------------")
        end
        return
    end
end, "POST", "D4rkLicenseSystem=" .. D4rkAC.License, {
    ["header"] = "application/json"
})

function Split(s, delimiter)
    result = {};
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match);
    end
    return result;
end

RegisterServerEvent("d4rkac:ScreenshotLog")
AddEventHandler("d4rkac:ScreenshotLog", function(link, player)
    local message = "[Click here](" .. link .. ") to see a Screenshot from Player " .. GetPlayerName(player) ..
                        " with ID: " .. player .. " requested by " .. GetPlayerName(source) .. " with ID: " .. source ..
                        "."
    local logembed = {{
        color = "15536915",
        title = "**D4rkAntiCheat**",
        description = message,
        footer = {
            text = "D4rkAC - " .. D4rkAC.Version .. " | " .. os.date("%Y/%m/%d %X")
        }
    }}
    PerformHttpRequest(ConfigServer.WebhookScreenshotRequests, function(err, text, headers)
    end, 'POST', json.encode({
        username = "D4rkAC | Screenshot Requests",
        embeds = logembed
    }), {
        ['Content-Type'] = 'application/json'
    })
end)

if ConfigServer.Framework == "ESX" then
    ESX.RegisterServerCallback("d4rkac:getAllPlayers", function(source, cb)
        for i = 1, #ESX.GetPlayers() do
            names[i] = GetPlayerName(ESX.GetPlayers()[i])
        end
        cb(ESX.GetPlayers(), names)
    end)
elseif ConfigServer.Framework == "QBCORE" then
    QBCore.Functions.CreateCallback("d4rkac:getAllPlayers", function(source, cb)
        for i = 1, #QBCore.Functions.GetPlayers() do
            names[i] = GetPlayerName(QBCore.Functions.GetPlayers()[i])
        end
        cb(QBCore.Functions.GetPlayers(), names)
    end)
end

local BlockedExplosions = {1, 2, 4, 5, 25, 32, 33, 35, 36, 37, 38}

AddEventHandler("explosionEvent", function(sender, ev)
    if ConfigServer.AntiExplosions then
        CancelEvent()
        for _, v in ipairs(BlockedExplosions) do
            if ev.explosionType == v then
                if not IsPlayerAceAllowed(sender, ConfigServer.AcePermission) then
                    TriggerEvent("d4rkac:BanPlayer", string.format(Locale[ConfigServer.Locale]["BanMessage"],
                        Locale[ConfigServer.Locale]["ExplosionDetected"]), "AntiCheat", sender,
                        Locale[ConfigServer.Locale]["ExplosionDetected"])
                end
            end
        end
    end
end)

RegisterServerEvent("d4rkac:KickPlayer")
AddEventHandler("d4rkac:KickPlayer", function(kickMessage, playerId)
    local _source = source
    DropPlayer(playerId, string.format(kickMessage, GetPlayerName(_source)))
end)

RegisterServerEvent("d4rkac:bring")
AddEventHandler("d4rkac:bring", function(target, coords)
    TriggerClientEvent("d4rkac:bring", target, coords)
end)

if ConfigServer.Framework == "ESX" then
    ESX.RegisterServerCallback("d4rkac:checkAce", function(source, cb)
        if IsPlayerAceAllowed(source, ConfigServer.AcePermission) then
            cb(true)
        end
        cb(false)
    end)
elseif ConfigServer.Framework == "QBCORE" then
    QBCore.Functions.CreateCallback("d4rkac:checkAce", function(source, cb)
        if IsPlayerAceAllowed(source, ConfigServer.AcePermission) then
            cb(true)
        end
        cb(false)
    end)
end

function LogToDiscordBan(playerid, log, link)
    local message
    if link == nil then
        message = log
    else
        message = log .. "\n**Screenshot:** [Click here](" .. link .. ")"
    end
    local logembed = {{
        color = "15536915",
        title = "**D4rkAntiCheat**",
        description = message,
        footer = {
            text = "D4rkAC - " .. D4rkAC.Version .. " | " .. os.date("%Y/%m/%d %X")
        }
    }}
    PerformHttpRequest(ConfigServer.WebhookBans, function(err, text, headers)
    end, 'POST', json.encode({
        username = "D4rkAC | Ban Logs",
        embeds = logembed
    }), {
        ['Content-Type'] = 'application/json'
    })
    PerformHttpRequest(ConfigServer.WebhookGeneral, function(err, text, headers)
    end, 'POST', json.encode({
        username = "D4rkAC | Ban Logs",
        embeds = logembed
    }), {
        ['Content-Type'] = 'application/json'
    })
end

function LogToDiscordTrigger(playerid, log)
    local logembed = {{
        ["color"] = "#ed1313",
        ["title"] = "**D4rkAntiCheat**",
        ["description"] = log,
        ["footer"] = {
            ["text"] = "D4rkAC - " .. D4rkAC.Version .. " | " .. os.date("%Y/%m/%d %X")
        }
    }}
    PerformHttpRequest(ConfigServer.WebhookTriggers, function(err, text, headers)
    end, 'POST', json.encode({
        username = "D4rkAC | Blacklist Triggers Logs",
        embeds = logembed
    }), {
        ['Content-Type'] = 'application/json'
    })
    PerformHttpRequest(ConfigServer.WebhookGeneral, function(err, text, headers)
    end, 'POST', json.encode({
        username = "D4rkAC | Blacklist Triggers Logs",
        embeds = logembed
    }), {
        ['Content-Type'] = 'application/json'
    })
end

function LogToDiscordObjects(playerid, log)
    local logembed = {{
        ["color"] = "#ed1313",
        ["title"] = "**D4rkAntiCheat**",
        ["description"] = log,
        ["footer"] = {
            ["text"] = "D4rkAC - " .. D4rkAC.Version .. " | " .. os.date("%Y/%m/%d %X")
        }
    }}
    PerformHttpRequest(ConfigServer.WebhookProps, function(err, text, headers)
    end, 'POST', json.encode({
        username = "D4rkAC | Blacklist Objects Logs",
        embeds = logembed
    }), {
        ['Content-Type'] = 'application/json'
    })
    PerformHttpRequest(ConfigServer.WebhookGeneral, function(err, text, headers)
    end, 'POST', json.encode({
        username = "D4rkAC | Blacklist Objects Logs",
        embeds = logembed
    }), {
        ['Content-Type'] = 'application/json'
    })
end

AddEventHandler('onResourceStart', function(resourceName)
    Citizen.Wait(1000)

    if GetCurrentResourceName() == resourceName then

        for k, v in pairs(Blacklist["Peds"]) do
            table.insert(BlacklistedObjectsList, GetHashKey(v))
        end
        for k, v in pairs(Blacklist["Props"]) do
            table.insert(BlacklistedObjectsList, GetHashKey(v))
        end
        for k, v in pairs(Blacklist["Vehicles"]) do
            table.insert(BlacklistedObjectsList, GetHashKey(string.upper(v)))
        end

        for k, v in pairs(Whitelist["Peds"]) do
            table.insert(WhitelistedObjectsList, GetHashKey(v))
        end
        for k, v in pairs(Whitelist["Props"]) do
            table.insert(WhitelistedObjectsList, GetHashKey(v))
        end
        for k, v in pairs(Whitelist["Vehicles"]) do
            table.insert(WhitelistedObjectsList, GetHashKey(v))
        end

        for k, trigger in pairs(Blacklist["Events"]) do
            RegisterServerEvent(trigger)
            AddEventHandler(trigger, function()
                local _source = source
                local License = nil
                local PlayerIP = nil
                local DiscordID = nil
                local PlayerName = GetPlayerName(_source)
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

                if PlayerIP == nil then
                    PlayerIP = GetPlayerEndpoint(_source)
                    if PlayerIP == nil then
                        PlayerIP = 'IP NOT FOUND'
                    end
                end
                if DiscordID == nil then
                    DiscordID = 'DISCORD NOT FOUND'
                end
                LogToDiscordTrigger(_source,
                    "**Player Name:** " .. PlayerName .. "\n**ServerID:** " .. _source .. "\n**SteamID:** " .. SteamID ..
                        "\n**License:** " .. License .. "\n**DiscordID:** " .. DiscordID .. "\n**Discord Tag:** <@" ..
                        DiscordID:gsub("discord:", "") .. ">\n**IP:** " .. PlayerIP:gsub("ip:", "") .. "\n**Trigger:** " ..
                        trigger)
                TriggerEvent("d4rkac:BanPlayer", string.format(Locale[ConfigServer.Locale]["BanMessage"], string.format(
                    Locale[ConfigServer.Locale]["BlacklistTrigger"], trigger)), "AntiCheat", _source,
                    string.format(Locale[ConfigServer.Locale]["BlacklistTrigger"], trigger))
                CancelEvent()
            end)
        end
    end
end)

AddEventHandler("entityCreating", function(entity)
    if ConfigServer.AntiBlacklistEntities then
        if DoesEntityExist(entity) then
            local _src = NetworkGetEntityOwner(entity)
            local model = GetEntityModel(entity)
            local _entitytype = GetEntityPopulationType(entity)
            if _src == nil then
                CancelEvent()
                return
            end

            if _entitytype == 0 then
                if inTable(WhitelistedObjectsList, model) == false then
                    if model ~= 0 and model ~= 225514697 then
                        if IsPlayerAceAllowed(_src, ConfigServer.AcePermission) then
                            return
                        end
                        logobjects(_src, model)
                        CancelEvent()

                        entitiesSpawned[_src] = (entitiesSpawned[_src] or 0) + 1
                        if entitiesSpawned[_src] > ConfigServer.MaxPropSpawn then
                            logobjectsmass(_src, entitiesSpawned[_src], model)
                            if IsPlayerAceAllowed(_src, ConfigServer.AcePermission) then
                                return
                            end

                            TriggerEvent("d4rkac:BanPlayer", string.format(Locale[ConfigServer.Locale]["BanMessage"],
                                Locale[ConfigServer.Locale]["MassPropSpawn"]), "AntiCheat", _src,
                                Locale[ConfigServer.Locale]["MassPropSpawn"])
                        end
                    end
                end
            end

            if GetEntityType(entity) == 3 then
                if _entitytype == 6 or _entitytype == 7 then
                    if model ~= 0 then
                        if IsPlayerAceAllowed(_src, ConfigServer.AcePermission) then
                            return
                        end
                        logobjects(_src, model)
                        TriggerEvent("d4rkac:BanPlayer", string.format(Locale[ConfigServer.Locale]["BanMessage"],
                            string.format(Locale[ConfigServer.Locale]["BlacklistProp"], model)), "AntiCheat", _src,
                            string.format(Locale[ConfigServer.Locale]["BlacklistProp"], model))
                        CancelEvent()

                        entitiesSpawned[_src] = (entitiesSpawned[_src] or 0) + 1
                        if entitiesSpawned[_src] > ConfigServer.MaxPropSpawn then
                            if IsPlayerAceAllowed(_src, ConfigServer.AcePermission) then
                                return
                            end
                            logobjectsmass(_src, entitiesSpawned[_src], model)
                            TriggerEvent("d4rkac:BanPlayer", string.format(Locale[ConfigServer.Locale]["BanMessage"],
                                Locale[ConfigServer.Locale]["MassPropSpawn"]), "AntiCheat", _src,
                                Locale[ConfigServer.Locale]["MassPropSpawn"])
                        end
                    end
                end
            else
                if GetEntityType(entity) == 2 then
                    if _entitytype == 6 or _entitytype == 7 then
                        if inTable(BlacklistedObjectsList, model) ~= false then
                            if model ~= 0 then
                                if IsPlayerAceAllowed(_src, ConfigServer.AcePermission) then
                                    return
                                end
                                logobjects(_src, model)
                                TriggerEvent("d4rkac:BanPlayer",
                                    string.format(Locale[ConfigServer.Locale]["BanMessage"],
                                        string.format(Locale[ConfigServer.Locale]["BlacklistVehicle"], model)),
                                    "AntiCheat", _src,
                                    string.format(Locale[ConfigServer.Locale]["BlacklistVehicle"], model))
                                CancelEvent()
                            end
                        end
                        vehiclesSpawned[_src] = (vehiclesSpawned[_src] or 0) + 1
                        if vehiclesSpawned[_src] > ConfigServer.MaxVehicleSpawn then
                            if IsPlayerAceAllowed(_src, ConfigServer.AcePermission) then
                                return
                            end
                            logobjectsmass(_src, vehiclesSpawned[_src], model)
                            TriggerEvent("d4rkac:BanPlayer", string.format(Locale[ConfigServer.Locale]["BanMessage"],
                                Locale[ConfigServer.Locale]["MassVehicleSpawn"]), "AntiCheat", _src,
                                Locale[ConfigServer.Locale]["MassVehicleSpawn"])
                            CancelEvent()
                        end
                    end
                elseif GetEntityType(entity) == 1 then
                    if _entitytype == 6 or _entitytype == 7 then
                        if inTable(BlacklistedObjectsList, model) ~= false then
                            if model ~= 0 or model ~= 225514697 then
                                if IsPlayerAceAllowed(_src, ConfigServer.AcePermission) then
                                    return
                                end
                                logobjects(_src, model)
                                TriggerEvent("d4rkac:BanPlayer", string.format(
                                    Locale[ConfigServer.Locale]["BanMessage"],
                                    Locale[ConfigServer.Locale]["BlacklistPeds"]), "AntiCheat", _src,
                                    Locale[ConfigServer.Locale]["BlacklistPeds"])
                                CancelEvent()
                            end
                        end
                        pedsSpawned[_src] = (pedsSpawned[_src] or 0) + 1
                        if pedsSpawned[_src] > ConfigServer.MaxPedsSpawn then
                            if IsPlayerAceAllowed(_src, ConfigServer.AcePermission) then
                                return
                            end
                            logobjectsmass(_src, pedsSpawned[_src], model)
                            TriggerEvent("d4rkac:BanPlayer", string.format(Locale[ConfigServer.Locale]["BanMessage"],
                                Locale[ConfigServer.Locale]["MassPedSpawn"]), "AntiCheat", _src,
                                Locale[ConfigServer.Locale]["MassPedSpawn"])
                        end
                    end
                else
                    if inTable(BlacklistedObjectsList, GetHashKey(entity)) ~= false then
                        if model ~= 0 or model ~= 225514697 then
                            if IsPlayerAceAllowed(_src, ConfigServer.AcePermission) then
                                return
                            end
                            logobjects(_src, model)
                            TriggerEvent("d4rkac:BanPlayer", string.format(Locale[ConfigServer.Locale]["BanMessage"],
                                string.format(Locale[ConfigServer.Locale]["BlacklistProp"], GetHashKey(entity))), "AntiCheat", _src,
                                string.format(Locale[ConfigServer.Locale]["BlacklistProp"], GetHashKey(entity)))
                            CancelEvent()
                        end
                    end
                end
            end
        end
    end
end)

inTable = function(table, item)
    for k, v in pairs(table) do
        if v == item then
            return true
        end
    end
    return false
end

function logobjectsmass(src, quantity, model)
    local License = nil
    local PlayerIP = nil
    local DiscordID = nil
    local PlayerName = GetPlayerName(src)
    local SteamID = nil

    for k, v in pairs(GetPlayerIdentifiers(src)) do
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
        PlayerIP = GetPlayerEndpoint(src)
        if PlayerIP == nil then
            PlayerIP = 'IP NOT FOUND'
        end
    end
    if DiscordID == nil then
        DiscordID = 'DISCORD NOT FOUND'
    end
    LogToDiscordObjects(src,
        "**Player Name:** " .. PlayerName .. "\n**ServerID:** " .. src .. "\n**SteamID:** " .. SteamID ..
            "\n**License:** " .. License .. "\n**DiscordID:** " .. DiscordID .. "\n**Discord Tag:** <@" ..
            DiscordID:gsub("discord:", "") .. ">\n**IP:** " .. PlayerIP:gsub("ip:", "") .. "\n**Object:** " .. model .."\n**Quantity:** "..quantity)
end

function logobjects(src, model)
    local License = nil
    local PlayerIP = nil
    local DiscordID = nil
    local PlayerName = GetPlayerName(src)
    local SteamID = nil

    for k, v in pairs(GetPlayerIdentifiers(src)) do
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
        PlayerIP = GetPlayerEndpoint(src)
        if PlayerIP == nil then
            PlayerIP = 'IP NOT FOUND'
        end
    end
    if DiscordID == nil then
        DiscordID = 'DISCORD NOT FOUND'
    end
    LogToDiscordObjects(src,
        "**Player Name:** " .. PlayerName .. "\n**ServerID:** " .. src .. "\n**SteamID:** " .. SteamID ..
            "\n**License:** " .. License .. "\n**DiscordID:** " .. DiscordID .. "\n**Discord Tag:** <@" ..
            DiscordID:gsub("discord:", "") .. ">\n**IP:** " .. PlayerIP:gsub("ip:", "") .. "\n**Object:** " .. model)
end

RegisterServerEvent("d4rkac:clearLoadout")
AddEventHandler("d4rkac:clearLoadout", function(id)
    local xPlayer = ESX.GetPlayerFromId(id)
    for i = #xPlayer.loadout, 1, -1 do
        xPlayer.removeWeapon(xPlayer.loadout[i].name)
    end
end)

RegisterServerEvent("d4rkac:clearInventory")
AddEventHandler("d4rkac:clearInventory", function(id)
    if ConfigServer.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(id)
        for k, v in ipairs(xPlayer.inventory) do
            if v.count > 0 then
                xPlayer.setInventoryItem(v.name, 0)
            end
        end
        xPlayer.setMoney(0)
    elseif ConfigServer.Framework == "QBCORE" then
        local Player = QBCore.Functions.GetPlayer(tonumber(id))
        Player.Functions.ClearInventory()
        Player.Functions.SetMoney('cash', 0)
    end
end)

RegisterCommand("d4rkac", function(source, args, rawCommand)
    if source == 0 then
        return
    end
    if IsPlayerAceAllowed(source, ConfigServer.AcePermission) then
        PerformHttpRequest("http://51.255.174.195:4455/", function(arg, request)
            TriggerClientEvent("d4rkac:openMenu", source, request)
        end)
    end
end)

RegisterCommand("d4rkacprint", function(source, args, rawCommand)
    if source ~= 0 then
        if IsPlayerAceAllowed(source, ConfigServer.AcePermission) then
            if not args[1] then
                return
            end
            TriggerClientEvent("d4rkac:ScreenshotRequestCommand", args[1])
        end
    else
        if not args[1] then
            return
        end
        TriggerClientEvent("d4rkac:ScreenshotRequestCommand", args[1])
    end
end)

AddEventHandler("clearPedTasksEvent", function(source, data)
    if ConfigServer.AntiClearPedTasksImmediately then
        if data.immediately and not IsPlayerAceAllowed(source, ConfigServer.AcePermission) then
            TriggerEvent("d4rkac:BanPlayer", string.format(Locale[ConfigServer.Locale]["BanMessage"],
                Locale[ConfigServer.Locale]["ClearPedTasks"]), "AntiCheat", source,
                Locale[ConfigServer.Locale]["ClearPedTasks"])
            CancelEvent()
        end
    end
end)
