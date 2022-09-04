ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Ultimate.GetTrigger("esx:getSharedObject"), function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

function GetUltimateObject()
    return Ultimate
end
