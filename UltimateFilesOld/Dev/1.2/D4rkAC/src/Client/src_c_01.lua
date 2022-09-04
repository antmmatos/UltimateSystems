-- Threads
ESX = nil
Spawned = false
QBCore = nil

Citizen.CreateThread(function()
    if Config.Framework == "ESX" then
        while ESX == nil do
            TriggerEvent(Config.ESX, function(obj)
                ESX = obj
            end)
            Citizen.Wait(0)
        end
    elseif Config.Framework == "QBCORE" then
        while QBCore == nil do
            QBCore = exports['qb-core']:GetCoreObject()
            Citizen.Wait(0)
        end
    end
end)

AddEventHandler("playerSpawned", function()
    Resources = GetNumResources()
    OriginalPed = GetEntityModel(PlayerPedId())
    Spawned = true
end)

-- SpeedHack
if Config.AntiSpeedHack then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            local speed = GetEntitySpeed(PlayerPedId())
            if not IsPedInAnyVehicle(PlayerPedId(), 0) then
                if speed > 80 then
                    TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                        Locale[Config.Locale]["SpeedHack"]), "AntiCheat", nil, Locale[Config.Locale]["SpeedHack"])
                end
            end
        end
    end)
end

-- Blacklist Weapon
if Config.AntiBlacklistWeapons then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            for _, weapon in pairs(Blacklist["Weapons"]) do
                if HasPedGotWeapon(PlayerPedId(), GetHashKey(weapon), false) then
                    if RemoveWeaponFromPed(PlayerPedId(), GetHashKey(weapon)) then
                        TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                            string.format(Locale[Config.Locale]["WeaponBlackList"], weapon)), "AntiCheat", nil,
                            string.format(Locale[Config.Locale]["WeaponBlackList"], weapon))
                    end
                end
            end
        end
    end)
end

-- Blocked CMDS
if Config.AntiBlacklistCommands then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            for _, cmds in ipairs(GetRegisteredCommands()) do
                for _, blockedcmds in ipairs(Blacklist["Commands"]) do
                    if cmds.name == blockedcmds then
                        TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                            string.format(Locale[Config.Locale]["CommandInjection"], blockedcmds)), "AntiCheat", nil,
                            string.format(Locale[Config.Locale]["CommandInjection"], blockedcmds))
                    end
                end
            end
        end
    end)
end

-- Spectate
if Config.AntiSpectate then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            if NetworkIsInSpectatorMode() then
                TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                    Locale[Config.Locale]["Spectate"]), "AntiCheat", nil, Locale[Config.Locale]["Spectate"])
            end
        end
    end)
end

-- Anti Infinite Ammo
if Config.AntiInfiniteAmmo then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2000)
            SetPedInfiniteAmmoClip(PlayerPedId(), false)
        end
    end)
end

-- Godmode
if Config.AntiGodmode then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            local PlayerPed = PlayerPedId()
            local PlayerPedHealth = GetEntityHealth(PlayerPed)
            SetEntityHealth(PlayerPed, PlayerPedHealth - 2)
            local RandomWait = math.random(10, 150)
            Citizen.Wait(RandomWait)
            if not IsPlayerDead(PlayerId()) then
                if PlayerPedId() == PlayerPed and GetEntityHealth(PlayerPed) == PlayerPedHealth and
                    GetEntityHealth(PlayerPed) ~= 0 then
                    TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                        Locale[Config.Locale]["Godmode"]), "AntiCheat", nil, Locale[Config.Locale]["Godmode"])
                elseif GetEntityHealth(PlayerPed) == PlayerPedHealth - 2 then
                    SetEntityHealth(PlayerPed, GetEntityHealth(PlayerPed) + 2)
                end
            end
            if GetEntityHealth(PlayerPedId()) > 200 then
                TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                    Locale[Config.Locale]["Godmode"]), "AntiCheat", nil, Locale[Config.Locale]["Godmode"])
            end
            if GetPedArmour(PlayerPedId()) < 200 then
                Wait(50)
                if GetPedArmour(PlayerPedId()) == 200 then
                    TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                        Locale[Config.Locale]["Godmode"]), "AntiCheat", nil, Locale[Config.Locale]["Godmode"])
                end
            end
        end
    end)
end

-- Thermal Vision
if Config.AntiThermalVision then
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        if GetUsingseethrough() then
            TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                Locale[Config.Locale]["ThermalVision"]), "AntiCheat", nil, Locale[Config.Locale]["ThermalVision"])
        end
    end)
end

-- Night Vision
if Config.AntiNightVision then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            if GetUsingnightvision() then
                TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                    Locale[Config.Locale]["NightVision"]), "AntiCheat", nil, Locale[Config.Locale]["NightVision"])
            end
        end
    end)
end

-- Invisible
if Config.AntiInvisible then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            local ped = PlayerPedId()
            if not IsEntityVisible(ped) then
                if Spawned then
                    TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                        Locale[Config.Locale]["Invisible"]), "AntiCheat", nil, Locale[Config.Locale]["Invisible"])
                end
            end
        end
    end)
end

-- SuperJump
if Config.AntiSuperJump then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            if IsPedJumping(PlayerPedId()) then
                local firstCoord = GetEntityCoords(PlayerPedId())
                while IsPedJumping(PlayerPedId()) do
                    Citizen.Wait(500)
                end
                local secondCoord = GetEntityCoords(PlayerPedId())
                local jumpLength = Vdist(firstCoord, secondCoord)
                if jumpLength > 30.0 then
                    TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                        Locale[Config.Locale]["SuperJump"]), "AntiCheat", nil, Locale[Config.Locale]["SuperJump"])
                end
            end
        end
    end)
end

-- CheatEngine
if Config.AntiCheatEngine then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2000)
            local PedVehicle = GetVehiclePedIsUsing(PlayerPedId())
            local PedVehicleModel = GetEntityModel(PedVehicle)
            if IsPedSittingInAnyVehicle(PlayerPedId()) then
                if PedVehicle == TempVehicle and PedVehicleModel ~= TempVehicleModel and TempVehicleModel ~= nil and
                    TempVehicleModel ~= 0 then
                    if Config.Framework == "ESX" then
                        SetEntityAsMissionEntity(PedVehicle, true, true)
                        DeleteVehicle(PedVehicle)
                    elseif Config.Framework == "QBCORE" then
                        QBCore.Functions.DeleteVehicle(PedVehicle)
                    end
                    TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                        Locale[Config.Locale]["CheatEngine"]), "AntiCheat", nil, Locale[Config.Locale]["CheatEngine"])
                end
            end
            TempVehicle = PedVehicle
            TempVehicleModel = PedVehicleModel
        end
    end)
end

-- FreeCam
if Config.AntiFreecam then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(500)
            if Spawned then
                local cam_coords = GetFinalRenderedCamCoord()
                local my_coords = GetEntityCoords(PlayerPedId())
                if GetDistanceBetweenCoords(my_coords, cam_coords, true) > 50.0 then
                    if cam_coords.z < 1000 then
                        TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                            Locale[Config.Locale]["Freecam"]), "AntiCheat", nil, Locale[Config.Locale]["Freecam"])
                    end
                end
            end
        end
    end)
end

-- Menyoo
if Config.AntiMenyoo then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            if Spawned then
                if IsPlayerCamControlDisabled() ~= false then
                    exports['screenshot-basic']:requestScreenshot(function(data)
                        TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                            Locale[Config.Locale]["Menyoo"], data), "AntiCheat", nil, Locale[Config.Locale]["Menyoo"])
                    end)
                end
            end
        end
    end)
end

-- Armor
if Config.AntiArmorExploit then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            local armor = GetPedArmour(PlayerPedId())
            if armor > Config.MaxArmor then
                TriggerServerEvent("d4rkac:BanPlayer",
                    string.format(Locale[Config.Locale]["BanMessage"], Locale[Config.Locale]["Armor"]), "AntiCheat",
                    nil, Locale[Config.Locale]["Armor"])
            end
        end
    end)
end

-- AimAssist
if Config.AntiAimAssist then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            local AimType = GetLocalPlayerAimState()
            if AimType ~= 3 then
                TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                    Locale[Config.Locale]["AimAssist"]), "AntiCheat", nil, Locale[Config.Locale]["AimAssist"])
            end
        end
    end)
end

-- Ped Changed
if Config.AntiPedChanger then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            if Spawned then
                if OriginalPed ~= GetEntityModel(PlayerPedId()) then
                    TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                        Locale[Config.Locale]["PedChanged"]), "AntiCheat", nil, Locale[Config.Locale]["PedChanged"])
                end
            end
        end
    end)
end

if Config.AntiTeleportNoClip then
    Citizen.CreateThread(function()
        while true do
            local playerPed = PlayerPedId()
            local playercoords = GetEntityCoords(PlayerPedId())
            if (playercoords.x > 0 or playercoords.x < 0) then
                Citizen.Wait(500)
                local newplayercoords = GetEntityCoords(PlayerPedId())
                if IsEntityDead(playerPed) then
                    playercoords = newplayercoords
                else
                    if (not IsPedInAnyVehicle(playerPed, 0) and not IsPedOnVehicle(playerPed) and
                        not IsPlayerRidingTrain(PlayerId())) then
                        if (GetDistanceBetweenCoords(playercoords.x, playercoords.y, playercoords.z, newplayercoords.x,
                            newplayercoords.y, newplayercoords.z, 0) > Config.MaxDistance) then
                            TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                                Locale[Config.Locale]["Teleport/NoClip"]), "AntiCheat", nil,
                                Locale[Config.Locale]["Teleport/NoClip"])
                        end
                    end
                    playercoords = newplayercoords
                end
            end
            Citizen.Wait(2000)
        end
    end)
end

-- AntiMenus
if Config.AntiInjectedMenu then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2000)
            local DetectableTextures = {{
                txd = "HydroMenu",
                txt = "HydroMenuHeader",
                name = "HydroMenu"
            }, {
                txd = "John",
                txt = "John2",
                name = "SugarMenu"
            }, {
                txd = "darkside",
                txt = "logo",
                name = "Darkside"
            }, {
                txd = "ISMMENU",
                txt = "ISMMENUHeader",
                name = "ISMMENU"
            }, {
                txd = "dopatest",
                txt = "duiTex",
                name = "Copypaste Menu"
            }, {
                txd = "fm",
                txt = "menu_bg",
                name = "Fallout Menu"
            }, {
                txd = "wave",
                txt = "logo",
                name = "Wave"
            }, {
                txd = "wave1",
                txt = "logo1",
                name = "Wave (alt.)"
            }, {
                txd = "meow2",
                txt = "woof2",
                name = "Alokas66",
                x = 1000,
                y = 1000
            }, {
                txd = "adb831a7fdd83d_Guest_d1e2a309ce7591dff86",
                txt = "adb831a7fdd83d_Guest_d1e2a309ce7591dff8Header6",
                name = "Guest Menu"
            }, {
                txd = "hugev_gif_DSGUHSDGISDG",
                txt = "duiTex_DSIOGJSDG",
                name = "HugeV Menu"
            }, {
                txd = "MM",
                txt = "menu_bg",
                name = "Metrix Mehtods"
            }, {
                txd = "wm",
                txt = "wm2",
                name = "WM Menu"
            }, {
                txd = "NeekerMan",
                txt = "NeekerMan1",
                name = "Lumia Menu"
            }, {
                txd = "Blood-X",
                txt = "Blood-X",
                name = "Blood-X Menu"
            }, {
                txd = "Dopamine",
                txt = "Dopameme",
                name = "Dopamine Menu"
            }, {
                txd = "Fallout",
                txt = "FalloutMenu",
                name = "Fallout Menu"
            }, {
                txd = "Luxmenu",
                txt = "Lux meme",
                name = "LuxMenu"
            }, {
                txd = "Reaper",
                txt = "reaper",
                name = "Reaper Menu"
            }, {
                txd = "absoluteeulen",
                txt = "Absolut",
                name = "Absolut Menu"
            }, {
                txd = "KekHack",
                txt = "kekhack",
                name = "KekHack Menu"
            }, {
                txd = "Maestro",
                txt = "maestro",
                name = "Maestro Menu"
            }, {
                txd = "SkidMenu",
                txt = "skidmenu",
                name = "Skid Menu"
            }, {
                txd = "Brutan",
                txt = "brutan",
                name = "Brutan Menu"
            }, {
                txd = "FiveSense",
                txt = "fivesense",
                name = "Fivesense Menu"
            }, {
                txd = "NeekerMan",
                txt = "NeekerMan1",
                name = "Lumia Menu"
            }, {
                txd = "Auttaja",
                txt = "auttaja",
                name = "Auttaja Menu"
            }, {
                txd = "BartowMenu",
                txt = "bartowmenu",
                name = "Bartow Menu"
            }, {
                txd = "Hoax",
                txt = "hoaxmenu",
                name = "Hoax Menu"
            }, {
                txd = "FendinX",
                txt = "fendin",
                name = "Fendinx Menu"
            }, {
                txd = "Hammenu",
                txt = "Ham",
                name = "Ham Menu"
            }, {
                txd = "Lynxmenu",
                txt = "Lynx",
                name = "Lynx Menu"
            }, {
                txd = "Oblivious",
                txt = "oblivious",
                name = "Oblivious Menu"
            }, {
                txd = "malossimenuv",
                txt = "malossimenu",
                name = "Malossi Menu"
            }, {
                txd = "memeeee",
                txt = "Memeeee",
                name = "Memeeee Menu"
            }, {
                txd = "tiago",
                txt = "Tiago",
                name = "Tiago Menu"
            }, {
                txd = "Hydramenu",
                txt = "hydramenu",
                name = "Hydra Menu"
            }}

            for _, data in pairs(DetectableTextures) do
                if data.x and data.y then
                    if GetTextureResolution(data.txd, data.txt).x == data.x and
                        GetTextureResolution(data.txd, data.txt).y == data.y then
                        TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                            Locale[Config.Locale]["LuaMenu"]), "AntiCheat", nil, Locale[Config.Locale]["LuaMenu"])
                    end
                else
                    if GetTextureResolution(data.txd, data.txt).x ~= 4.0 then
                        TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"],
                            Locale[Config.Locale]["LuaMenu"]), "AntiCheat", nil, Locale[Config.Locale]["LuaMenu"])
                    end
                end
            end
        end
    end)
end

for _, eventName in pairs(Blacklist["Events"]) do
    RegisterNetEvent(eventName)
    AddEventHandler(eventName, function()
        CancelEvent()
        TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"], string.format(
            Locale[Config.Locale]["EventsBlacklist"], eventName)), "AntiCheat", nil,
            string.format(Locale[Config.Locale]["EventsBlacklist"], eventName))
    end)
end
