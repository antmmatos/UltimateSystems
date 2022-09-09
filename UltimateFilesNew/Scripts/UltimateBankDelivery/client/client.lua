Ultimate = nil
ESX = nil
isStarted = false
data = {}

Citizen.CreateThread(function()
    Ultimate = exports["UltimateCore"]:GetUltimateObject()
    while ESX == nil do
        TriggerEvent(Ultimate.GetTrigger("esx:getSharedObject"), function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent(Ultimate.GetTrigger("esx:setJob"))
AddEventHandler(Ultimate.GetTrigger("esx:setJob"), function(job)
    ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    local ped
    local pedCoords
    local sleep
    while true do
        sleep = 2000
        ped = PlayerPedId()
        pedCoords = GetEntityCoords(ped)
        if ESX.PlayerData.job.name == "merryweather" then
            if Vdist(pedCoords, Config.StartingBank.x, Config.StartingBank.y, Config.StartingBank.z) > 1.5 then
                sleep = 0
                if not isStarted then
                    DrawText3Ds(Config.StartingBank.x, Config.StartingBank.y, Config.StartingBank.z,
                        Locale[Config.Locale]["start_work"])
                else
                    DrawText3Ds(Config.StartingBank.x, Config.StartingBank.y, Config.StartingBank.z,
                        Locale[Config.Locale]["stop_work"])
                end
            end
        else
            sleep = 5000
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    local ped
    local pedCoords
    local sleep
    while true do
        sleep = 2000
        ped = PlayerPedId()
        pedCoords = GetEntityCoords(ped)
        if ESX.PlayerData.job.name == "merryweather" then
            if Vdist(pedCoords, Config.StartingBank.x, Config.StartingBank.y, Config.StartingBank.z) < 1.5 then
                sleep = 0
                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("UltimateBankDelivery:StartWork")
                end
            end
        else
            sleep = 5000
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    local ped
    local pedCoords
    local sleep
    while true do
        sleep = 2000
        ped = PlayerPedId()
        pedCoords = GetEntityCoords(ped)
        if ESX.PlayerData.job.name == "merryweather" then
            if isStarted then
                if Vdist(pedCoords, Config.RefillPoint.x, Config.RefillPoint.y, Config.RefillPoint.z) > 1.5 then
                    sleep = 0
                    DrawText3Ds(Config.RefillPoint.x, Config.RefillPoint.y, Config.RefillPoint.z,
                        Locale[Config.Locale]["pickup_bags"])
                end
            else
                sleep = 5000
            end
        else
            sleep = 5000
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    local ped
    local pedCoords
    local sleep
    while true do
        sleep = 2000
        ped = PlayerPedId()
        pedCoords = GetEntityCoords(ped)
        if ESX.PlayerData.job.name == "merryweather" then
            if isStarted then
                if Vdist(pedCoords, Config.RefillPoint.x, Config.RefillPoint.y, Config.RefillPoint.z) < 1.5 then
                    sleep = 0
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent("UltimateBankDelivery:PickupBags")
                    end
                end
            else
                sleep = 5000
            end
        else
            sleep = 5000
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    local ped
    local pedCoords
    local sleep
    while true do
        sleep = 2000
        ped = PlayerPedId()
        pedCoords = GetEntityCoords(ped)
        if ESX.PlayerData.job.name == "merryweather" then
            if isStarted then
                for k, v in pairs(Config.Banks) do
                    if Vdist(pedCoords, v.x, v.y, v.z) < 1.5 then
                        sleep = 0
                        DrawText3Ds(v.x, v.y, v.z, "[E] - Delivery money\nBalance: $" .. data[k])
                    end
                end
            else
                sleep = 5000
            end
        else
            sleep = 5000
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    local ped
    local pedCoords
    local sleep
    while true do
        sleep = 2000
        ped = PlayerPedId()
        pedCoords = GetEntityCoords(ped)
        if ESX.PlayerData.job.name == "merryweather" then
            if isStarted then
                for k, v in pairs(Config.Banks) do
                    if Vdist(pedCoords, v.x, v.y, v.z) < 1.5 then
                        sleep = 0
                        if IsControlJustReleased(0, 38) then
                            TriggerServerEvent("UltimateBankDelivery:DeliveryMoney", k)
                        end
                    end
                end
            else
                sleep = 5000
            end
        else
            sleep = 5000
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent("UltimateBankDelivery:RefreshData")
AddEventHandler("UltimateBankDelivery:RefreshData", function(data)
    data = data
end)

RegisterNetEvent("Ultimate:WorkStatusChanged")
AddEventHandler("Ultimate:WorkStatusChanged", function(status)
    isStarted = status
end)

function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
