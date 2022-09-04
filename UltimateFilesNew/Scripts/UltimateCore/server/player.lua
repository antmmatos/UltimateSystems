AddEventHandler(Ultimate.GetTrigger("esx:playerLoaded"), function(playerId, xPlayer)
    if Validated then
        local userData = {}
        if UltimateValidLicenses["UltimateCryptoSystem"] == true then
            UltimateCryptoSystem = exports["UltimateCryptoSystem"]:GetUltimateCryptoSystemObject()
            local result
            if Config.MySQLSystem == "mysql-async" then
                result = MySQL.Async.fetchAll(
                    "SELECT COUNT(*) AS 'Exists', identifier, name, accounts FROM UltimateCryptoSystem WHERE identifier = @identifier",
                    {
                        ["@identifier"] = xPlayer.getIdentifier()
                    })
            elseif Config.MySQLSystem == "oxmysql" then
                result = MySQL.query.await(
                    "SELECT COUNT(*) AS 'Exists', identifier, name, accounts FROM UltimateCryptoSystem WHERE identifier = ?",
                    {xPlayer.getIdentifier()})
            end
            if result[1].Exists == 1 then
                userData.accounts = json.decode(result[1].accounts)
                userData.identifier = result[1].identifier
                userData.name = result[1].name
                userData.source = playerId
                if Ultimate.isAdmin(playerId) then
                    userData.isAdmin = true
                else
                    userData.isAdmin = false
                end
                local uPlayer = Ultimate.CreatePlayer(userData)
                Ultimate.Players[playerId] = uPlayer
            else
                local accounts = {}
                for k, v in pairs(UltimateCryptoSystem.CryptoCurrencies) do
                    accounts[UltimateCryptoSystem.CryptoCurrencies[k]["name"]] = 0
                end
                MySQL.Async.fetchAll(
                    "INSERT INTO UltimateCryptoSystem (identifier, name, accounts) VALUES (@identifier, @name, @accounts)",
                    {
                        ["@identifier"] = xPlayer.getIdentifier(),
                        ["@name"] = GetPlayerName(playerId),
                        ["@accounts"] = json.encode(accounts)
                    })
                userData.accounts = accounts
                userData.identifier = xPlayer.getIdentifier()
                userData.name = GetPlayerName(playerId)
                userData.source = playerId
                if Ultimate.isAdmin(playerId) then
                    userData.isAdmin = true
                else
                    userData.isAdmin = false
                end
                local uPlayer = Ultimate.CreatePlayer(userData)
                Ultimate.Players[playerId] = uPlayer
            end
        else
            userData.identifier = xPlayer.getIdentifier()
            userData.name = GetPlayerName(playerId)
            userData.source = playerId
            if Ultimate.isAdmin(playerId) then
                userData.isAdmin = true
            else
                userData.isAdmin = false
            end
            local uPlayer = Ultimate.CreatePlayer(userData)
            Ultimate.Players[playerId] = uPlayer
        end
    end
end)

AddEventHandler("playerDropped", function()
    if Validated then
        local _source = source
        if UltimateValidLicenses["UltimateCryptoSystem"] == true then
            MySQL.update.await("UPDATE UltimateCryptoSystem SET accounts = ? WHERE identifier = ?", {json.encode(
                Ultimate.Players[_source].getAccounts()), Ultimate.Players[_source].getIdentifier()})
        end
        Ultimate.Players[_source] = nil
    end
end)
