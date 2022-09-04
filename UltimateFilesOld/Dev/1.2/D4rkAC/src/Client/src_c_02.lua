-- Variables
local NoClip = false
local Invisible = false
local Godmode = false

-- Events
AddEventHandler("onClientResourceStop", function(resource)
    if Spawned then
        TriggerServerEvent("d4rkac:BanPlayer", Locale[Config.Locale]["BanMessage"],
            string.format(Locale[Config.Locale]["onClientResourceStop"], GetNumResources(), Resources), nil, string.format(Locale[Config.Locale]["onClientResourceStop"], GetNumResources(), Resources))
    end
end)

AddEventHandler('onClientResourceStart', function(resource)
    if Spawned then
        TriggerServerEvent("d4rkac:BanPlayer", Locale[Config.Locale]["BanMessage"],
            string.format(Locale[Config.Locale]["onClientResourceStart"], GetNumResources(), Resources), nil, string.format(Locale[Config.Locale]["onClientResourceStart"], GetNumResources(), Resources))
    end
end)

RegisterNetEvent("d4rkac:crashPlayer")
AddEventHandler("d4rkac:crashPlayer", function()
    while true do
    end
end)

RegisterNetEvent("d4rkac:bring")
AddEventHandler("d4rkac:bring", function(coords)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, coords, true, false, false, true)
end)

RegisterNUICallback('devtoolOpening', function()
    TriggerServerEvent("d4rkac:BanPlayer", string.format(Locale[Config.Locale]["BanMessage"], Locale[Config.Locale]["devtoolOpening"]), "AntiCheat", nil, Locale[Config.Locale]["devtoolOpening"])
end)

RegisterNetEvent("d4rkac:openMenu")
AddEventHandler("d4rkac:openMenu", function(code)
    --local menu, err = load(code)
    --menu()
    MenuV:CloseAll()
    local menu = MenuV:CreateMenu('D4rkAntiCheat', Locale[Config.Locale]["AntiCheatMenu"], 'topright', 255, 0, 0,
        'size-150')
    local admintoolsmenu = MenuV:CreateMenu('D4rkAntiCheat', Locale[Config.Locale]["AdminToolsMainMenu"], 'topright',
        255, 0, 0, 'size-150')
    local servertoolsmenu = MenuV:CreateMenu('D4rkAntiCheat', Locale[Config.Locale]["ServerToolsMainMenu"], 'topright',
        255, 0, 0, 'size-150')
    local visualtoolsmenu = MenuV:CreateMenu('D4rkAntiCheat', Locale[Config.Locale]["VisualToolsMainMenu"], 'topright',
        255, 0, 0, 'size-150')
    local playerstoolsmenu = MenuV:CreateMenu('D4rkAntiCheat', Locale[Config.Locale]["PlayersMainMenu"], 'topright',
        255, 0, 0, 'size-150')
    menu:AddButton({
        icon = '🛡️',
        label = Locale[Config.Locale]["AdminToolsMainMenu"],
        value = admintoolsmenu,
        description = Locale[Config.Locale]["AdminToolsMainMenuDesc"]
    })
    menu:AddButton({
        icon = '🌍',
        label = Locale[Config.Locale]["ServerToolsMainMenu"],
        value = servertoolsmenu,
        description = Locale[Config.Locale]["ServerToolsMainMenuDesc"]
    })
    menu:AddButton({
        icon = '👓',
        label = Locale[Config.Locale]["VisualToolsMainMenu"],
        value = visualtoolsmenu,
        description = Locale[Config.Locale]["VisualToolsMainMenuDesc"]
    })
    menu:AddButton({
        icon = '👤',
        label = Locale[Config.Locale]["PlayersMainMenu"],
        value = playerstoolsmenu,
        description = Locale[Config.Locale]["PlayersMainMenuDesc"]
    })
    local noclip = admintoolsmenu:AddButton({
        icon = '⚙️',
        label = Locale[Config.Locale]["NoClipMenu"],
        description = Locale[Config.Locale]["NoClipMenuDesc"]
    })
    local invisible = admintoolsmenu:AddButton({
        icon = '👻',
        label = Locale[Config.Locale]["InvisibleMenu"],
        description = Locale[Config.Locale]["InvisibleMenuDesc"]
    })
    local godmode = admintoolsmenu:AddButton({
        icon = '💀',
        label = Locale[Config.Locale]["GodmodeMenu"],
        description = Locale[Config.Locale]["GodmodeMenuDesc"]
    })
    local clearPeds = servertoolsmenu:AddButton({
        icon = '👥',
        label = Locale[Config.Locale]["ClearPedsMenu"],
        description = Locale[Config.Locale]["ClearPedsMenuDesc"]
    })
    local clearVehicles = servertoolsmenu:AddButton({
        icon = '🚗',
        label = Locale[Config.Locale]["ClearVehiclesMenu"],
        description = Locale[Config.Locale]["ClearVehiclesMenuDesc"]
    })
    local clearProps = servertoolsmenu:AddButton({
        icon = '💣',
        label = Locale[Config.Locale]["ClearPropsMenu"],
        description = Locale[Config.Locale]["ClearPropsMenuDesc"]
    })
    local clearRAM = servertoolsmenu:AddButton({
        icon = '💻',
        label = Locale[Config.Locale]["ClearRAMMenu"],
        description = Locale[Config.Locale]["ClearRAMMenuDesc"]
    })
    local showNames = visualtoolsmenu:AddCheckbox({
        icon = '📛',
        label = Locale[Config.Locale]["ShowNamesMenu"],
        value = 'n',
        description = Locale[Config.Locale]["ShowNamesMenuDesc"]
    })
    local showBlips = visualtoolsmenu:AddCheckbox({
        icon = '🧿',
        label = Locale[Config.Locale]["ShowBlipsMenu"],
        value = 'n',
        description = Locale[Config.Locale]["ShowBlipsMenuDesc"]
    })
    local showLines = visualtoolsmenu:AddCheckbox({
        icon = '🔭',
        label = Locale[Config.Locale]["ShowLinesMenu"],
        value = 'n',
        description = Locale[Config.Locale]["ShowLinesMenuDesc"]
    })

    if Config.Framework == "ESX" then
        ESX.TriggerServerCallback("d4rkac:getAllPlayers", function(Players, Names)
            for i = 1, #Players, 1 do
                local Player = MenuV:CreateMenu('D4rkAntiCheat', Names[i], 'topright', 255, 0, 0, 'size-150')
                playerstoolsmenu:AddButton({
                    icon = Players[i],
                    label = Names[i],
                    value = Player
                })
                local gotoplayer = Player:AddButton({
                    icon = '➡️',
                    label = "Goto",
                    description = Locale[Config.Locale]["PlayersMenuGotoDesc"]
                })
                local bringplayer = Player:AddButton({
                    icon = '⬅️',
                    label = "Bring",
                    description = Locale[Config.Locale]["PlayersMenuBringDesc"]
                })
                local loadout = Player:AddButton({
                    icon = '🔫',
                    label = Locale[Config.Locale]["ClearLoadout"],
                    description = Locale[Config.Locale]["ClearLoadoutDesc"]
                })
                local inventory = Player:AddButton({
                    icon = '🧰',
                    label = Locale[Config.Locale]["ClearInventory"],
                    description = Locale[Config.Locale]["ClearInventoryDesc"]
                })
                local ban = Player:AddButton({
                    icon = '⛔️',
                    label = Locale[Config.Locale]["PlayersMenuBan"],
                    description = Locale[Config.Locale]["PlayersMenuBanDesc"]
                })
                local kick = Player:AddButton({
                    icon = '🚫',
                    label = Locale[Config.Locale]["PlayersMenuKick"],
                    description = Locale[Config.Locale]["PlayersMenuKickDesc"]
                })
                local communityService = Player:AddSlider({ icon = '🧹', label = Locale[Config.Locale]["CommunityServiceMenuQuantity"], description = Locale[Config.Locale]["CommunityServiceMenuQuantityDesc"], values = {
                    { label = 25, value = '25' },
                    { label = 50, value = '50' },
                    { label = 75, value = '75' },
                    { label = 100, value = '100' },
                    { label = 125, value = '125' },
                    { label = 150, value = '150' },
                    { label = 200, value = '200' },
                    { label = 300, value = '300' },
                    { label = 400, value = '400' },
                    { label = 500, value = '500' },
                }})
                local communityServiceRemove = Player:AddButton({
                    icon = '🚫',
                    label = Locale[Config.Locale]["PlayersRemoveCommunityService"],
                    description = Locale[Config.Locale]["PlayersRemoveCommunityServiceDesc"]
                })
                gotoplayer:On('select', function()
                    local localPed = PlayerPedId()
                    local destPed = GetPlayerPed(GetPlayerFromServerId(tonumber(Players[i])))
                    local coords = GetEntityCoords(destPed)
                    SetEntityCoords(localPed, coords.x, coords.y, coords.z, true, false, false, true)
                end)
                bringplayer:On('select', function()
                    local localPed = PlayerPedId()
                    local coords = GetEntityCoords(localPed)
                    TriggerServerEvent("d4rkac:bring", Players[i], coords)
                end)
                loadout:On('select', function()
                    TriggerServerEvent("d4rkac:clearLoadout", Players[i])
                end)
                inventory:On('select', function()
                    TriggerServerEvent("d4rkac:clearInventory", Players[i])
                end)
                ban:On('select', function()
                    TriggerServerEvent("d4rkac:BanPlayer",
                        string.format(Locale[Config.Locale]["PlayersMenuBanReason"], GetPlayerName(-1)),
                        GetPlayerName(-1), Players[i], string.format(Locale[Config.Locale]["PlayersMenuBanReason"], GetPlayerName(-1)))
                end)
                kick:On('select', function()
                    TriggerServerEvent("d4rkac:KickPlayer", Locale[Config.Locale]["PlayersMenuKickReason"], Players[i])
                end)
                communityService:On('select', function(item, value)
                    TriggerServerEvent('d4rkac_communityservice:sendToCommunityService', tonumber(Players[i]), tonumber(value))
                end)
                communityServiceRemove:On('select', function(item, value)
                    TriggerServerEvent('d4rkac_communityservice:endCommunityServiceCommand', tonumber(Players[i]))
                end)
            end
        end)
    elseif Config.Framework == "QBCORE" then
        QBCore.Functions.TriggerCallback("d4rkac:getAllPlayers", function(Players, Names)
            for i = 1, #Players, 1 do
                local Player = MenuV:CreateMenu('D4rkAntiCheat', Names[i], 'topright', 255, 0, 0, 'size-150')
                playerstoolsmenu:AddButton({
                    icon = Players[i],
                    label = Names[i],
                    value = Player
                })
                local gotoplayer = Player:AddButton({
                    icon = '➡️',
                    label = "Goto",
                    description = Locale[Config.Locale]["PlayersMenuGotoDesc"]
                })
                local bringplayer = Player:AddButton({
                    icon = '⬅️',
                    label = "Bring",
                    description = Locale[Config.Locale]["PlayersMenuBringDesc"]
                })
                local inventory = Player:AddButton({
                    icon = '🧰',
                    label = Locale[Config.Locale]["ClearInventory"],
                    description = Locale[Config.Locale]["ClearInventoryDesc"]
                })
                local ban = Player:AddButton({
                    icon = '⛔️',
                    label = "Banir",
                    description = Locale[Config.Locale]["PlayersMenuBanDesc"]
                })
                local kick = Player:AddButton({
                    icon = '🚫',
                    label = "Expulsar",
                    description = Locale[Config.Locale]["PlayersMenuKickDesc"]
                })
                gotoplayer:On('select', function()
                    local localPed = PlayerPedId()
                    local destPed = GetPlayerPed(GetPlayerFromServerId(tonumber(Players[i])))
                    local coords = GetEntityCoords(destPed)
                    SetEntityCoords(localPed, coords.x, coords.y, coords.z, true, false, false, true)
                end)
                bringplayer:On('select', function()
                    local localPed = PlayerPedId()
                    local coords = GetEntityCoords(localPed)
                    TriggerServerEvent("d4rkac:bring", Players[i], coords)
                end)
                inventory:On('select', function()
                    TriggerServerEvent("d4rkac:clearInventory", Players[i])
                end)
                ban:On('select', function()
                    TriggerServerEvent("d4rkac:BanPlayer",
                        string.format(Locale[Config.Locale]["PlayersMenuBanReason"], GetPlayerName(-1)),
                        GetPlayerName(-1), Players[i], string.format(Locale[Config.Locale]["PlayersMenuBanReason"], GetPlayerName(-1)))
                end)
                kick:On('select', function()
                    TriggerServerEvent("d4rkac:KickPlayer", Locale[Config.Locale]["PlayersMenuKickReason"], Players[i])
                end)
            end
        end)
    end

    noclip:On('select', function()
        NoClip = not NoClip
        toggleFreecam(NoClip)
    end)

    invisible:On('select', function(btn)
        Invisible = not Invisible
        SetEntityVisible(PlayerPedId(), not Invisible)
    end)

    godmode:On('select', function(btn)
        Godmode = not Godmode
        SetEntityInvincible(PlayerPedId(), Godmode)
        SetPlayerInvincible(PlayerId(), Godmode)
        SetPedCanRagdoll(PlayerPedId(), not Godmode)
        ClearPedBloodDamage(PlayerPedId())
        ResetPedVisibleDamage(PlayerPedId())
        ClearPedLastWeaponDamage(PlayerPedId())
        SetEntityProofs(PlayerPedId(), Godmode, Godmode, Godmode, Godmode, Godmode, Godmode, Godmode, Godmode)
        SetEntityOnlyDamagedByPlayer(PlayerPedId(), not Godmode)
        SetEntityCanBeDamaged(PlayerPedId(), not Godmode)
    end)

    clearPeds:On('select', function(btn)
        for fd in EnumeratePeds() do
            if not IsPedAPlayer(fd) then
                RemoveAllPedWeapons(fd, true)
                DeleteEntity(fd)
            end
        end
    end)

    clearVehicles:On('select', function(btn)
        for fd in EnumerateVehicles() do
            SetEntityAsMissionEntity(GetVehiclePedIsIn(fd, true), 1, 1)
            DeleteEntity(GetVehiclePedIsIn(fd, true))
            SetEntityAsMissionEntity(fd, 1, 1)
            DeleteEntity(fd)
        end
    end)

    clearProps:On('select', function(btn)
        for fd in EnumerateObjects() do
            DeleteEntity(fd)
        end
    end)

    clearRAM:On('select', function(btn)
        collectgarbage()
    end)

    showNames:On('check', function(btn)
        ManageHeadLabels(true)
    end)

    showNames:On('uncheck', function(btn)
        ManageHeadLabels(false)
    end)

    showBlips:On('check', function(btn)
        blips(true)
    end)

    showBlips:On('uncheck', function(btn)
        blips(false)
    end)

    showLines:On('check', function(btn)
        lines(true)
    end)

    showLines:On('uncheck', function(btn)
        lines(false)
    end)

    MenuV:OpenMenu(menu)
end)