function Ultimate.CreatePlayer(userData)
    local self = {}

    self.identifier = userData.identifier
    self.name = userData.name
    self.source = userData.source
    self.Admin = userData.isAdmin
    if UltimateValidLicenses["UltimateCryptoSystem"] == true then
        self.CryptoAccounts = userData.accounts
        function self.addCrypto(crypto, quantity)
            if UltimateCryptoSystem.IsCryptoValid(crypto) then
                self.CryptoAccounts[crypto] = self.CryptoAccounts[crypto] + quantity
            else
                print("^7[^2UltimateCryptoSystem^7] Invalid addCrypto function for player " .. self.name ..
                          " with Crypto " .. crypto .. ".")
            end
        end

        function self.removeCrypto(crypto, quantity)
            if UltimateCryptoSystem.IsCryptoValid(crypto) then
                self.CryptoAccounts[crypto] = self.CryptoAccounts[crypto] - quantity
            else
                print("^7[^2UltimateCryptoSystem^7] Invalid removeCrypto function for player " .. self.name ..
                          " with Crypto " .. crypto .. ".")
            end
        end

        function self.setCrypto(crypto, quantity)
            if UltimateCryptoSystem.IsCryptoValid(crypto) then
                self.CryptoAccounts[crypto] = quantity
            else
                print("^7[^2UltimateCryptoSystem^7] Invalid setCrypto function for player " .. self.name ..
                          " with Crypto " .. crypto .. ".")
            end
        end

        function self.getCrypto(crypto)
            return self.CryptoAccounts[crypto]
        end

        function self.getAccounts()
            return self.CryptoAccounts
        end

        function self.getAccount(account)
            return self.CryptoAccounts[account]
        end
    end

    if UltimateValidLicenses["UltimateAC"] == true then
        function self.ban(target, banMessage, admin, logBanMessage, link, isManual)
            target = tonumber(target)
            if target == nil or target <= 0 or target == '' then if target == nil then target = 'nil' end return end
            if isManual then
                logBanMessage = logBanMessage:gsub("You have been permanently banned from the server.\n", "")
            end
            if target == nil then
                return
            end
            if link == nil then
                link = ""
            end
            if admin == nil then
                admin = "AntiCheat"
            end
            local License = nil
            local PlayerIP = nil
            local DiscordID = nil
            local PlayerName = GetPlayerName(target)
            local SteamID = nil
            local date = os.date("%Y/%m/%d %H:%M")

            for k, v in pairs(GetPlayerIdentifiers(target)) do
                if string.sub(v, 1, string.len("license:")) == "license:" then
                    License = v
                elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
                    PlayerIP = v
                elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                    DiscordID = v
                elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
                    SteamID = v
                end
            end
            if not License then
                License = "license:none"
            end
            if not SteamID then
                SteamID = "steam:none"
            end
            if not DiscordID then
                DiscordID = "discord:none"
            end
            if not PlayerIP then
                PlayerIP = "ip:none"
            end
            if PlayerIP == nil then
                PlayerIP = GetPlayerEndpoint(target)
                if PlayerIP == nil then
                    PlayerIP = 'IP NOT FOUND'
                end
            end
            if DiscordID == nil then
                DiscordID = 'DISCORD NOT FOUND'
            end
            if not PlayerName then return end
            if not isManual then
                MySQL.Sync.execute(
                    'INSERT INTO UltimateAC (PlayerName, SteamID, License, DiscordID, PlayerIP, Date, Reason, Admin, Screenshot) VALUES (@PlayerName, @SteamID, @License, @DiscordID, @PlayerIP, @Date, @Reason, @Admin, @Screenshot)',
                    {
                        ['@PlayerName'] = PlayerName,
                        ['@SteamID'] = SteamID,
                        ['@License'] = License,
                        ['@DiscordID'] = DiscordID,
                        ['@PlayerIP'] = PlayerIP,
                        ['@Date'] = date,
                        ['@Reason'] = logBanMessage,
                        ['@Admin'] = admin,
                        ['@Screenshot'] = link
                    }, function()
                    end)
            else
                MySQL.Sync.execute(
                    'INSERT INTO UltimateAC (PlayerName, SteamID, License, DiscordID, PlayerIP, Date, Reason, Admin, Screenshot, isManual) VALUES (@PlayerName, @SteamID, @License, @DiscordID, @PlayerIP, @Date, @Reason, @Admin, @Screenshot, @isManual)',
                    {
                        ['@PlayerName'] = PlayerName,
                        ['@SteamID'] = SteamID,
                        ['@License'] = License,
                        ['@DiscordID'] = DiscordID,
                        ['@PlayerIP'] = PlayerIP,
                        ['@Date'] = date,
                        ['@Reason'] = logBanMessage,
                        ['@Admin'] = admin,
                        ['@Screenshot'] = link,
                        ['@isManual'] = "1"
                    }, function()
                    end)
            end
            Citizen.Wait(1000)
            exports["UltimateAC"]:LoadBans()
            
            exports["UltimateAC"]:LogToDiscordBan(target,
                "**Player Name:** " .. PlayerName .. "\n**ServerID:** " .. target .. "\n**SteamID:** " .. SteamID ..
                    "\n**License:** " .. License .. "\n**DiscordID:** " .. DiscordID .. "\n**Discord Tag:** <@" ..
                    DiscordID:gsub("discord:", "") .. ">\n**IP:** " .. PlayerIP:gsub("ip:", "") .. "\n**Reason:** " ..
                    logBanMessage, link)
            if not GetPlayerName(target) then return end
            DropPlayer(target, banMessage)
        end

        function self.crash()
            TriggerClientEvent("UltimateAC:CrashPlayer", self.source)
        end
    end

    function self.getIdentifier()
        return self.identifier
    end

    function self.showNotification(msg)
        Ultimate.ShowNotification(self.source, msg)
    end

    function self.kick(reason, admin)
        DropPlayer(tonumber(self.source), string.format(reason, admin))
    end

    function self.isAdmin()
        return self.Admin
    end

    return self
end
