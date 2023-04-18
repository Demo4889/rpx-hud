local RPX = exports['rpx-core']:GetObject()

RegisterCommand("cash", function(source, args, rawCommand)
    local Player = RPX.GetPlayer(source)
    if not Player then return end

    TriggerClientEvent('hud:client:ShowAccounts', source, 'cash', Player.money.cash)
end)

RegisterCommand("bank", function(source, args, rawCommand)
    local Player = RPX.GetPlayer(source)
    if not Player then return end

    TriggerClientEvent('hud:client:ShowAccounts', source, 'bank', Player.money.bank)
end)