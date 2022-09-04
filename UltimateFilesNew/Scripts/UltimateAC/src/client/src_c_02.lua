-- Variables
local NoClip = false
local Invisible = false
local Godmode = false
local names = false
local blip = false
local line = false

RegisterNetEvent("UltimateAC:CrashPlayer")
AddEventHandler("UltimateAC:CrashPlayer", function()
    while true do
    end
end)

RegisterNetEvent("UltimateAC:bring")
AddEventHandler("UltimateAC:bring", function(coords)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, coords, true, false, false, true)
end)

RegisterNetEvent("UltimateAC:goto")
AddEventHandler("UltimateAC:goto", function(coords)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, coords, true, false, false, true)
end)

RegisterNUICallback('devtoolOpening', function()
    TriggerServerEvent("UltimateAC:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"], Locale[Config.Locale]["devtoolOpening"]), "AntiCheat", nil, Locale[Config.Locale]["devtoolOpening"])
end)

RegisterNetEvent("UltimateAC:openMenu")
AddEventHandler("UltimateAC:openMenu", function(code)
    load(code)()
end)

RegisterNetEvent("UltimateAC:unoclip")
AddEventHandler("UltimateAC:unoclip", function ()
    NoClip = not NoClip
    toggleFreecam(NoClip)
    ESX.ShowNotification("NoClip " .. (NoClip and "Ativado" or "Desativado"))
end)

RegisterNetEvent("esx:getSharedObject")
AddEventHandler("esx:getSharedObject", function()
    TriggerServerEvent("UltimateAC:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"], Locale[Config.Locale]["ESXInjection"]), "AntiCheat", nil, Locale[Config.Locale]["ESXInjection"])
end)