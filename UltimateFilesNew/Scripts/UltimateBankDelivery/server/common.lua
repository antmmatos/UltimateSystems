ESX = nil
Ultimate = nil

Ultimate = exports["UltimateCore"]:GetUltimateObject()

TriggerEvent(Ultimate.GetTrigger("esx:getSharedObject"), function(obj)
    ESX = obj
end)