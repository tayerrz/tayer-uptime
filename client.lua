ESX = nil
ESX = exports["es_extended"]:getSharedObject()

RegisterCommand('onlinetime', function(source, args, rawCommand)
    ESX.TriggerServerCallback('tayer-uptime:getOnlineTime', function(onlineTime)
        ESX.ShowNotification('您在线时长: ~g~' .. onlineTime .. ' 分钟')
    end)
end)
