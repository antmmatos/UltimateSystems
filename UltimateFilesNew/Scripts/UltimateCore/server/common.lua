ESX = nil

TriggerEvent(Ultimate.GetTrigger("esx:getSharedObject"), function(obj)
    ESX = obj
end)

function GetUltimateObject()
    return Ultimate
end
