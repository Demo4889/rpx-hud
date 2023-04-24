RegisterNetEvent('hud:client:ShowAccounts', function(type, amount)
    if type == 'cash' then
        SendNUIMessage({
            action = 'show',
            type = 'cash',
            cash = string.format("%.2f", amount)
        })
    elseif type == 'bank' then
        SendNUIMessage({
            action = 'show',
            type = 'bank',
            bank = string.format("%.2f", amount)
        })
    end
end)

RegisterNetEvent('hud:client:OnMoneyChange', function(type, amount, isMinus)
    SendNUIMessage({
        action = 'update',
        cash = LocalPlayer.state.money.cash,
        bank = LocalPlayer.state.money.bank,
        amount = amount,
        minus = isMinus,
        type = type,
    })
end)