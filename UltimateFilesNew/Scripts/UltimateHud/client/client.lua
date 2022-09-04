ESX = nil
Ultimate = nil
hunger = 0
thirst = 0
Validated = false
voice = 2
driving = false

Ultimate = exports["UltimateCore"]:GetUltimateObject()

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Ultimate.GetTrigger("esx:getSharedObject"), function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(0)
    end
    ESX.PlayerData = ESX.GetPlayerData()
    repeat
        Ultimate.CallCallback("UltimateHud:IsValidated", function(validated)
            Validated = validated
        end)
        Citizen.Wait(1000)
    until Validated
    if Validated then
        Start()
    end
end)

RegisterNetEvent("pma-voice:setTalkingMode")
AddEventHandler("pma-voice:setTalkingMode", function(mode)
    voice = mode
end)

RegisterNetEvent("UltimateHud:SetVoice")
AddEventHandler("UltimateHud:SetVoice", function(level)
    voice = level
end)

RegisterNetEvent(Config.EventNames["esx_status:onTick"])
AddEventHandler(Config.EventNames["esx_status:onTick"], function(status)
    if Validated then
        TriggerEvent(Config.EventNames["esx_status:getStatus"], 'hunger', function(status)
            hunger = status.val / 10000
        end)
        TriggerEvent(Config.EventNames["esx_status:getStatus"], 'thirst', function(status)
            thirst = status.val / 10000
        end)
    end
end)

function Start()
    Citizen.CreateThread(function()
        DisplayRadar(Config.ShowMap)
        local ped = PlayerPedId()
        SendNUIMessage({
            start = true,
            health = (GetEntityHealth(ped) - 100),
            armour = GetPedArmour(ped),
            hunger = hunger,
            thirst = thirst,
            stamina = (100 - GetPlayerSprintStaminaRemaining(PlayerId()))
        })
    end)
end

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    while true do
        local ped = PlayerPedId()
        SendNUIMessage({
            refresh = true,
            health = (GetEntityHealth(ped) - 100),
            armour = GetPedArmour(ped),
            hunger = hunger,
            thirst = thirst,
            stamina = (100 - GetPlayerSprintStaminaRemaining(PlayerId())),
            voice = voice
        })
        if Config.ShowMapOnCar and not Config.ShowMap then
            local ped = PlayerPedId()
            DisplayRadar(driving)
            SendNUIMessage({
                showMap = driving,
                setMap = true
            })
        elseif Config.ShowMapOnCar and Config.ShowMap then
            DisplayRadar(true)
            SendNUIMessage({
                showMap = true,
                setMap = true
            })
        end
        if IsPedInAnyVehicle(ped, false) then
            SendNUIMessage({
                inCar = true
            })
            driving = true
        else
            SendNUIMessage({
                outCar = true
            })
            driving = false
        end
        Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
    local ped = PlayerPedId()
    while true do
        if driving then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local vehiclefuel
            if Config.LegacyFuel then
                vehiclefuel = math.floor(exports["LegacyFuel"]:GetFuel(vehicle))
            else
                vehiclefuel = math.floor(GetVehicleFuelLevel(vehicle))
            end
            SendNUIMessage({
                isToSetSpeed = true,
                setVel = math.floor(GetEntitySpeed(GetVehiclePedIsIn(ped, false)) * 3.6),
                fuel = vehiclefuel,
                carfix = GetVehicleBodyHealth(vehicle) / 10
            })
            Citizen.Wait(0)
        else
            Citizen.Wait(1000)
        end
    end
end)