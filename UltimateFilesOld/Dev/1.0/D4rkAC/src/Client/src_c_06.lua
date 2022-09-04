_TriggerServerEvent = TriggerServerEvent

TriggerServerEvent = function(eventName, ...)
    if string.find(eventName, "esx:") or string.find(eventName, "esx_") then
        TriggerServerEvent("d4rkac:BanPlayer",
            string.format(Locale[Config.Locale]["BanMessage"], Locale[Config.Locale]["ESXInjection"]), "AntiCheat", nil,
            Locale[Config.Locale]["ESXInjection"])
    else
        _TriggerServerEvent(eventName, ...)
    end
end