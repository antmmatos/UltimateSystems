data = {}
isStarted = nil

Citizen.CreateThread(function()
    Validated = exports["UltimateCore"]:getAuth(GetCurrentResourceName(), Config.Version)

    Citizen.CreateThread(function()
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

Citizen.CreateThread(function()

end)

RegisterServerEvent("Ultimate:StartWork")
AddEventHandler("Ultimate:StartWork", function()
    if not source then
        local _source = source
        isStarted = _source
        TriggerClientEvent("Ultimate:WorkStatusChanged", source, true)
        TriggerClientEvent(Ultimate.GetTrigger("esx:showNotification"), source,
            Locale[Config.Locale]["work_status_changed"])
    else
        TriggerClientEvent(Ultimate.GetTrigger("esx:showNotification"), source, Locale[Config.Locale]["already_started"])
    end
end)

RegisterServerEvent("Ultimate:DeliveryMoney")
AddEventHandler("Ultimate:DeliveryMoney", function(bank)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem().count >= 1 then
        data[bank] = (data[bank] + 500000) > 10000000 and 10000000 or (data[bank] + 500000)
        xPlayer.removeInventoryItem("moneybag", 1)
        TriggerClientEvent(Ultimate.GetTrigger("esx:showNotification"), source, Locale[Config.Locale]["delivery_success"
            ])
    else
        TriggerClientEvent(Ultimate.GetTrigger("esx:showNotification"), source, Locale[Config.Locale]["no_money_bags"])
    end
end)

RegisterServerEvent("Ultimate:PickupBags")
AddEventHandler("Ultimate:PickupBags", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem().count < 20 then
        xPlayer.addInventoryItem("moneybag", 10)
        TriggerClientEvent(Ultimate.GetTrigger("esx:showNotification"), source, Locale[Config.Locale]["received_bags"])
    else
        TriggerClientEvent(Ultimate.GetTrigger("esx:showNotification"), source, Locale[Config.Locale]["max_bags"])
    end
end)

Citizen.CreateThread(function()
    data = json.decode(LoadResourceFile(GetCurrentResourceName(), "./data.json"))

    if not data then
        print("^7[^2UltimateAC^7] An error occurred while loading data.json, recreating...")
        SaveResourceFile(GetCurrentResourceName(), "./data.json", json.encode({}), -1)
        data = {}
    end
    if data == {} then
        for k, v in pairs(Config.Banks) do
            data[k] = 10000000
        end
    end

end)
