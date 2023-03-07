ESX = nil
ESX = exports["es_extended"]:getSharedObject()

MySQL.ready(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `users_online_time` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `identifier` varchar(255) NOT NULL,
            `online_time` int(11) NOT NULL DEFAULT '0',
            PRIMARY KEY (`id`),
            UNIQUE KEY `identifier` (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ]], {}, function(rowsChanged)
        print('tayer-uptime: Created online time table')
    end)
end)

ESX.RegisterServerCallback('tayer-uptime:getOnlineTime', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local identifier = xPlayer.identifier
        local query = [[SELECT online_time FROM users_online_time WHERE identifier = @identifier]]
        local values = {['@identifier'] = identifier}

        MySQL.Async.fetchAll(query, values, function(result)
            if result[1] ~= nil then
                cb(result[1].online_time)
            else
                cb(0)
            end
        end)
    else
        cb(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- Wait 1 minute
        for _, player in ipairs(GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(player)
            if xPlayer then
                local identifier = xPlayer.identifier
                local query = [[UPDATE users_online_time SET online_time = online_time + 1 WHERE identifier = @identifier]]
                local values = {['@identifier'] = identifier}
                MySQL.Async.execute(query, values, function(rowsChanged)
                    if rowsChanged == 0 then
                        query = [[INSERT INTO users_online_time (identifier, online_time) VALUES (@identifier, @online_time)]]
                        values = {['@identifier'] = identifier, ['@online_time'] = 1}
                        MySQL.Async.execute(query, values, function(rowsChanged)
                            print('tayer-uptime: Inserted new user with identifier ' .. identifier)
                        end)
                    end
                end)
            end
        end
    end
end)
