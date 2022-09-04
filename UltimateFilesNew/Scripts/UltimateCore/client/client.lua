Ultimate = {}
Ultimate.RegisteredServerCallbacks = {}
Ultimate.RequestId = 0

function Ultimate.CallCallback(name, cb, ...)
    Ultimate.RegisteredServerCallbacks[Ultimate.RequestId] = cb

    TriggerServerEvent('UltimateSystems:CallCallback', name, Ultimate.RequestId, ...)

    if Ultimate.RequestId < 65535 then
        Ultimate.RequestId = Ultimate.RequestId + 1
    else
        Ultimate.RequestId = 0
    end
end

RegisterNetEvent('UltimateSystems:ServerCallback')
AddEventHandler('UltimateSystems:ServerCallback', function(requestId, ...)
    Ultimate.RegisteredServerCallbacks[requestId](...)
    Ultimate.RegisteredServerCallbacks[requestId] = nil
end)

function Ultimate.GetTrigger(trigger)
    if Config.EventNames[trigger] then
        return Config.EventNames[trigger]
    else
        print("^7[^2UltimateCryptoSystem^7] Invalid trigger " .. trigger .. ".")
        return
    end
end