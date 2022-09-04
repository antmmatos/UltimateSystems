AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        VerifyResStop(resourceName)
    end
end)

AddEventHandler('onClientResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        VerifyResStop(resourceName)
    end
end)

_G.AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        VerifyResStop(resourceName)
    end
end)

_G.AddEventHandler('onClientResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        VerifyResStop(resourceName)
    end
end)

function VerifyResStop(rn)
    TriggerServerEvent("UltimateAC:ScriptBan", GetNumResources(), Resources)
    return CancelEvent()
end

local DarArma = GiveWeaponToPed
GiveWeaponToPed = function(ped, weaponhash, ...)
    local player = PedToNet(ped)
    TriggerServerEvent('UltimateAC:AddWeapon', player, weaponhash)
    return DarArma(ped, weaponhash, ...)
end

local RemoveArma = RemoveWeaponFromPed
RemoveWeaponFromPed = function(ped, weaponhash, ...)
    local player = PedToNet(ped)
    TriggerServerEvent('UltimateAC:RemoveWeapon', player, weaponhash)
    return RemoveArma(ped, weaponhash, ...)
end

local RemoveAllArma = RemoveAllPedWeapons
RemoveAllPedWeapons = function(ped, ...)
    local player = PedToNet(ped)
    TriggerServerEvent('UltimateAC:ClearWeapons', player)
    return RemoveAllArma(ped, ...)
end
