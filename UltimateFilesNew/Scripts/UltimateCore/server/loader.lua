turnoff = os.exit
UltimateValidLicenses = {
    ["UltimateCore"] = false,
    ["UltimateAC"] = false,
    ["UltimateCryptoSystem"] = false,
    ["UltimateHud"] = false,
    ["UltimateBankDelivery"] = false
}

function ExitIfCore(scriptName)
    if scriptName ~= "UltimateCore" then
        return
    end
    Citizen.Wait(7500)
    turnoff()
end

local function _obj(obj)
    local s = msgpack.pack(obj)
    return s, #s
end

local httpDispatch = {}
AddEventHandler('__cfx_internal:httpResponse', function(token, status, body, headers, errorData)
    if httpDispatch[token] then
        local userCallback = httpDispatch[token]
        httpDispatch[token] = nil
        userCallback(status, body, headers, errorData)
    end
end)

function sendHttpRequest(url, cb, method, data, headers, options)
    local followLocation = true

    if options and options.followLocation ~= nil then
        followLocation = options.followLocation
    end

    local t = {
        url = url,
        method = method or 'GET',
        data = data or '',
        headers = headers or {},
        followLocation = followLocation
    }

    local id = internalSendHttpRequest(t)

    if id ~= -1 then
        httpDispatch[id] = cb
    else
        cb(0, nil, {}, 'Failure handling HTTP request')
    end
end

function internalSendHttpRequest(requestData)
    local requestData_bytes, requestData_len = _obj(requestData)
    return Citizen.InvokeNative(0x6b171e87, requestData_bytes, requestData_len, Citizen.ResultAsInteger())
end

function getAuth(script, version)
    sendHttpRequest("http://localhost/index.php", function(arg, request)
        if arg == 200 then
            local data = json.decode(request)
            if data then
                if data["Error"] then
                    print("===================================================")
                    print("^7|| ^1[UltimateSystem] ^7|| ^4Version: " .. version .. "^7")
                    print("^7|| ^1[UltimateSystem] ^7|| ^4Script: " .. script .. "^7")
                    print("^7|| ^1[UltimateSystem] ^7|| ^4Error: ^1" .. data["Error"] .. "^7")
                    print("===================================================")
                    StopResource(script)
                    Citizen.InvokeNative(0x21783161, script)
                    ExitIfCore(script)
                    return false
                else
                    local es_extended = GetResourceState(Config.FrameworkName)
                    if es_extended ~= "started" then
                        print("===================================================")
                        print("^7|| ^1[UltimateSystem] ^7|| ^4Version: ^1" .. version .. "^7")
                        print("^7|| ^1[UltimateSystem] ^7|| ^4Script: ^1" .. script .. "^7")
                        print("^7|| ^1[UltimateSystem] ^7|| ^1ESX not detected!^7")
                        print("===================================================")
                        StopResource(script)
                        Citizen.InvokeNative(0x21783161, script)
                        ExitIfCore(script)
                        return false
                    end
                    print("===================================================")
                    print("^7|| ^1[UltimateSystem] ^7|| ^2License Authorized!^7")
                    print("^7|| ^1[UltimateSystem] ^7|| ^7Welcome back, ^1" .. data["OwnerName"] .. "^7!")
                    print("^7|| ^1[UltimateSystem] ^7|| ^7Script: ^1" .. script .. "^7")
                    print("^7|| ^1[UltimateSystem] ^7|| ^7Version: ^1" .. version .. "^7")
                    if not data["isLifetime"] then
                        if tonumber(data["TimeLeft"]) > 1 then
                            print("^7|| ^1[UltimateSystem] ^7|| Time left: ^1" .. data["TimeLeft"] .. " ^7days")
                        else
                            print("^7|| ^1[UltimateSystem] ^7|| Time left: ^1" .. data["TimeLeft"] .. " ^7day")
                        end
                    end
                    print("===================================================")
                    UltimateValidLicenses[script] = true
                    Citizen.CreateThread(function ()
                        if tonumber(data["Version"]) ~= tonumber(version) then
                            print("\n========================================================")
                            print("^7|| ^1[UltimateSystem] ^7|| ^7Script: ^1" .. script .. "^7")
                            print("^7|| ^1[UltimateSystem] ^7|| ^4Version: " .. Config.Version .. "^7")
                            print("^7|| ^1[UltimateSystem] ^7|| ^4New version: " .. data["Version"] .. "^7")
                            print("^7|| ^1[UltimateSystem] ^7|| ^1Update it to get new features!^7")
                            print("===================================================")
                        end
                    end)
                    return true
                end
            else
                print(request)
                print("===================================================")
                print("^7|| ^1[UltimateSystem] ^7|| ^4Version: " .. version .. "^7")
                print("^7|| ^1[UltimateSystem] ^7|| ^4Script: " .. script .. "^7")
                print("^7|| ^1[UltimateSystem] ^7|| ^1Authentication Error!^7")
                print("===================================================")
                StopResource(script)
                Citizen.InvokeNative(0x21783161, script)
                ExitIfCore(script)
                return false
            end
        else
            print("===================================================")
            print("^7|| ^1[UltimateSystem] ^7|| ^4Version: " .. version .. "^7")
            print("^7|| ^1[UltimateSystem] ^7|| ^4Script: " .. script .. "^7")
            print("^7|| ^1[UltimateSystem] ^7|| ^1Authentication Error!^7")
            print("===================================================")
            StopResource(script)
            Citizen.InvokeNative(0x21783161, script)
            ExitIfCore(script)
            return false
        end
    end, "POST", "License=" .. Licenses[script] .. "&Script=" .. script, {
        ["header"] = "application/json"
    })
end
