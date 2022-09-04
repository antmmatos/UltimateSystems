Validated = nil
Ultimate = exports["UltimateCore"]:GetUltimateObject()

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
    Ultimate.CreateCallback("UltimateHud:IsValidated", function(source, cb)
        cb(Validated)
    end)
end)

RegisterServerEvent("mumble:SetVoiceData")
AddEventHandler("mumble:SetVoiceData", function(data, level)
    if data == "mode" then
        TriggerClientEvent("UltimateHud:SetVoice", source, level)
    end
end)