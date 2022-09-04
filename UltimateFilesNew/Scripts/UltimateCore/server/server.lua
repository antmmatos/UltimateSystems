Ultimate = {}
Ultimate.RegisteredServerCallbacks = {}
Ultimate.Players = {}

Citizen.CreateThread(function()
    Validated = getAuth(GetCurrentResourceName(), Config.Version)

    Citizen.CreateThread(function ()
        while not Validated do
            TriggerEvent("UltimateCore:getLicensesStatus", function(status)
                if status[GetCurrentResourceName()] then
                    Validated = true
                else
                    Validated = false
                end
            end)
            Citizen.Wait(1000)
        end
    end)
end)

-- Server Callbacks
function Ultimate.CreateCallback(name, cb)
    Ultimate.RegisteredServerCallbacks[name] = cb
end

function Ultimate.CallCallback(name, requestId, source, cb, ...)
    if Ultimate.RegisteredServerCallbacks[name] then
        Ultimate.RegisteredServerCallbacks[name](source, cb, ...)
    end
end

RegisterServerEvent('UltimateSystems:CallCallback')
AddEventHandler('UltimateSystems:CallCallback', function(name, requestId, ...)
    local playerId = source

    Ultimate.CallCallback(name, requestId, playerId, function(...)
        TriggerClientEvent('UltimateSystems:ServerCallback', playerId, requestId, ...)
    end, ...)
end)

-- Functions
function Ultimate.isAdmin(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    for _, v in pairs(Config.AdminGroups) do
        if xPlayer.getGroup() == v then
            return true
        end
    end
    return false
end

function Ultimate.isSourceZero(playerId)
    if playerId == 0 then
        return true
    else
        return false
    end
end

function Ultimate.GetPlayerFromId(playerId)
    return Ultimate.Players[tonumber(playerId)]
end

function Ultimate.GetTrigger(trigger)
    if Config.EventNames[trigger] then
        return Config.EventNames[trigger]
    else
        print("^7[^2UltimateCryptoSystem^7] Invalid trigger " .. trigger .. ".")
        return
    end
end

function Ultimate.Split(s, delimiter)
    result = {};
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result;
end

RegisterNetEvent("UltimateCore:getLicensesStatus")
AddEventHandler("UltimateCore:getLicensesStatus", function(cb)
    cb(UltimateValidLicenses)
end)
