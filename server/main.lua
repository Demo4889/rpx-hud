RPX = exports['rpx-core']:GetObject()

RegisterCommand("cash", function(source, args, rawCommand)
    local Player = RPX.GetPlayer(source)
    local cashamount = Player.money.cash
    if cashamount ~= nil then
        TriggerClientEvent('hud:client:ShowAccounts', source, 'cash', cashamount)
    else
        return
    end
end)

RegisterCommand("bank", function(source, args, rawCommand)
    local Player = RPX.GetPlayer(source)
    local bankamount = Player.money.bank
    if bankamount ~= nil then
        TriggerClientEvent('hud:client:ShowAccounts', source, 'bank', bankamount)
    else
        return
    end
end)
