local filestring = 'client_script "@' .. GetCurrentResourceName() .. '/src/Client/src_c_06.lua"'
local installedResourcesNum

RegisterCommand("ultimatemanager", function(source, args, rawCommand)
    if Validated then
        if source == 0 then
            local found
            if not args[1] then
                print("----------------------------------------------------------------")
                print("^7|| ^1[UltimateAC] ^7|| ^1Use ^2/Ultimatemanager [install/uninstall] [none/fx].^7")
                print("----------------------------------------------------------------")
                return
            end
            if args[1] == "install" then
                installedResourcesNum = 0
                if args[2] == "fx" then
                    local resourcenumber = GetNumResources()
                    local installedResources = {}
                    for i = 0, resourcenumber - 1 do
                        local path = GetResourcePath(GetResourceByFindIndex(i))
                        local File = io.open(path .. "/fxmanifest.lua", "r")
                        if File then
                            if not string.find(path, GetCurrentResourceName()) then
                                if string.len(path) > 4 then
                                    local File = io.open(path .. "/fxmanifest.lua", "r")
                                    for line in io.lines(path .. "/fxmanifest.lua") do
                                        if line == filestring then
                                            found = true
                                        end
                                    end
                                    if not found then
                                        File = io.open(path .. "/fxmanifest.lua", "a+")
                                        File:write("\n\n" .. filestring)
                                        File:close()
                                        table.insert(installedResources, GetResourceByFindIndex(i))
                                        installedResourcesNum = installedResourcesNum + 1
                                    end
                                end
                            end
                        end
                    end
                    print("----------------------------------------------------------------")
                    print("^7|| ^1[UltimateAC] ^7|| ^1Installed on ^2" .. installedResourcesNum .. " ^1resources.^7")
                    if installedResourcesNum ~= 0 then
                        print("^7|| ^1[UltimateAC] ^7|| ^1List of resources: ^7")
                        for i = 1, #installedResources do
                            print("^7|| ^1[UltimateAC] ^7|| ^1 - ^2" .. installedResources[i])
                        end
                    end
                    print("^7|| ^1[UltimateAC] ^7|| ^1Restart the server to apply.^7")
                    print("----------------------------------------------------------------")
                elseif args[2] == nil then
                    local resourcenumber = GetNumResources()
                    local installedResources = {}
                    for i = 0, resourcenumber - 1 do
                        local path = GetResourcePath(GetResourceByFindIndex(i))
                        local File = io.open(path .. "/__resource.lua", "r")
                        if File then
                            if not string.find(path, GetCurrentResourceName()) then
                                if string.len(path) > 4 then
                                    local File = io.open(path .. "/__resource.lua", "r")
                                    for line in io.lines(path .. "/__resource.lua") do
                                        if line == filestring then
                                            found = true
                                        end
                                    end
                                    if not found then
                                        File = io.open(path .. "/__resource.lua", "a+")
                                        File:write("\n\n" .. filestring)
                                        File:close()
                                        table.insert(installedResources, GetResourceByFindIndex(i))
                                        installedResourcesNum = installedResourcesNum + 1
                                    end
                                end
                            end
                        end
                    end
                    print("----------------------------------------------------------------")
                    print("^7|| ^1[UltimateAC] ^7|| ^1Installed on ^2" .. installedResourcesNum .. " ^1resources.^7")
                    if installedResourcesNum ~= 0 then
                        print("^7|| ^1[UltimateAC] ^7|| ^1List of resources: ^7")
                        for i = 1, #installedResources do
                            print("^7|| ^1[UltimateAC] ^7|| ^1 - ^2" .. installedResources[i])
                        end
                    end
                    print("^7|| ^1[UltimateAC] ^7|| ^1Restart the server to apply.^7")
                    print("----------------------------------------------------------------")
                end
            elseif args[1] == "uninstall" then
                if args[2] == "fx" then
                    local resourcenumber = GetNumResources()
                    for i = 0, resourcenumber - 1 do
                        local path = GetResourcePath(GetResourceByFindIndex(i))
                        local File = io.open(path .. "/fxmanifest.lua", "r")
                        if File then
                            if string.len(path) > 4 then
                                File:seek("set", 0)
                                local read = File:read("*a")
                                File:close()
                                local splited = Split(read, "\n")
                                local stringmodified = ""
                                for _, v in ipairs(splited) do
                                    if v == filestring then
                                        local filetomodify = io.open(path .. "/fxmanifest.lua", "w")
                                        if filetomodify then
                                            filetomodify:seek("set", 0)
                                            filetomodify:write(stringmodified)
                                            filetomodify:close()
                                        end
                                    else
                                        stringmodified = stringmodified .. v .. "\n"
                                    end
                                end
                            end
                        end
                    end
                    print("----------------------------------------------------------------")
                    print("^7|| ^1[UltimateAC] ^7|| ^1Uninstalled from ^2fxmanifest.lua ^1with success.^7")
                    print("^7|| ^1[UltimateAC] ^7|| ^1Restart the server to apply.^7")
                    print("----------------------------------------------------------------")
                elseif args[2] == nil then
                    local resourcenumber = GetNumResources()
                    for i = 0, resourcenumber - 1 do
                        local path = GetResourcePath(GetResourceByFindIndex(i))
                        local File = io.open(path .. "/__resource.lua", "r")
                        if File then
                            if string.len(path) > 4 then
                                File:seek("set", 0)
                                local read = File:read("*a")
                                File:close()
                                local splited = Split(read, "\n")
                                local stringmodified = ""
                                for _, v in ipairs(splited) do
                                    if v == filestring then
                                        local filetomodify = io.open(path .. "/__resource.lua", "w")
                                        if filetomodify then
                                            filetomodify:seek("set", 0)
                                            filetomodify:write(stringmodified)
                                            filetomodify:close()
                                        end
                                    else
                                        stringmodified = stringmodified .. v .. "\n"
                                    end
                                end
                            end
                        end
                    end
                    print("----------------------------------------------------------------")
                    print("^7|| ^1[UltimateAC] ^7|| ^1Uninstalled from ^2__resource.lua ^1with success.^7")
                    print("^7|| ^1[UltimateAC] ^7|| ^1Restart the server to apply.^7")
                    print("----------------------------------------------------------------")
                end
            end
        else
            TriggerClientEvent(Ultimate.GetTrigger("esx:showNotification"), source,
                "This command can be only executed on console.")
        end
    end
end)
