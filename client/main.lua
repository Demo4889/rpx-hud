RPX = exports['rpx-core']:GetObject()
local speed = 0.0
local radarActive = false
local stress = 0
local youhavemail = false

-- functions
local function GetShakeIntensity(stresslevel)
    local retval = 0.05
    for _, v in pairs(Config.Intensity['shake']) do
        if stresslevel >= v.min and stresslevel <= v.max then
            retval = v.intensity
            break
        end
    end
    return retval
end

local function GetEffectInterval(stresslevel)
    local retval = 60000
    for _, v in pairs(Config.EffectInterval) do
        if stresslevel >= v.min and stresslevel <= v.max then
            retval = v.timeout
            break
        end
    end
    return retval
end

RegisterCommand("hud", function(source, args, rawCommand)
    LocalPlayer.state.UIHidden = not LocalPlayer.state.UIHidden
end)

-- Player HUD
CreateThread(function()
    while true do
        Wait(500)
        if LocalPlayer.state.isLoggedIn and LocalPlayer.state.UIHidden ~= true then
            local show = true
            local player = PlayerPedId()
            local playerid = PlayerId()
            if IsPauseMenuActive() then
                show = false
            end
            if Citizen.InvokeNative(0x25B7A0206BDFAC76, GetHashKey("MAP")) then
                show = false
            end
            local voice = 0
            local talking = Citizen.InvokeNative(0x33EEF97F, playerid)
            if LocalPlayer.state['proximity'] then
                voice = LocalPlayer.state['proximity'].distance
            end
            local stamina = tonumber(string.format("%.2f", Citizen.InvokeNative(0x0FF421E467373FCF, PlayerId(), Citizen.ResultAsFloat())))
            local mounted = IsPedOnMount(PlayerPedId())
            ---@type any
            local horsehealth = 0 
            ---@type any
            local horsestam = 0 
            if mounted then
                local horse = GetMount(PlayerPedId())
                local maxHealth = Citizen.InvokeNative(0x4700A416E8324EF3, horse, Citizen.ResultAsInteger())
                local maxStamina = Citizen.InvokeNative(0xCB42AFE2B613EE55, horse, Citizen.ResultAsFloat())
                horsehealth = tonumber(
                    string.format(
                        "%.2f", Citizen.InvokeNative(0x82368787EA73C0F7, horse) / maxHealth * 100 
                    )
                )
                horsestam = tonumber(
                    string.format(
                        "%.2f", Citizen.InvokeNative(0x775A1CA7893AA8B5, horse, Citizen.ResultAsFloat()) / maxStamina * 100
                    )
                )
            end

            SendNUIMessage({
                action = 'hudtick',
                show = show,
                health = GetEntityHealth(player) / 6, -- health in red dead max health is 600 so dividing by 6 makes it 100 here
                armor = 0,
                thirst = LocalPlayer.state.metadata['thirst'],
                hunger = LocalPlayer.state.metadata['hunger'],
                stress = LocalPlayer.state.metadata['stress'],
                onHorse = mounted,
                horsehealth = horsehealth,
                horsestamina = horsestam,
                stamina = stamina,
                talking = talking,
                voice = voice,
                youhavemail = youhavemail,
            })
        else
            SendNUIMessage({
                action = 'hudtick',
                show = false,
            })
        end
    end
end)

-- Money HUD
RegisterNetEvent('hud:client:ShowAccounts', function(type, amount)
    if type == 'cash' then
        SendNUIMessage({
            action = 'show',
            type = 'cash',
            cash = string.format("%.2f", amount)
        })
    elseif type == 'bloodmoney' then
        SendNUIMessage({
            action = 'show',
            type = 'bloodmoney',
            bloodmoney = string.format("%.2f", amount)
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
        bloodmoney = 0,
        bank = LocalPlayer.state.money.bank,
        amount = amount,
        minus = isMinus,
        type = type,
    })
end)

-- Stress Gain

CreateThread(function() -- Speeding
    while true do
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                speed = GetEntitySpeed(GetVehiclePedIsIn(ped, false)) * 2.237 --mph
                if speed >= Config.MinimumSpeed then
                    TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                end
            end
        end
        Wait(20000)
    end
end)

CreateThread(function() -- Shooting
    while true do
        if LocalPlayer.state.isLoggedIn then
            if IsPedShooting(PlayerPedId()) then
                if math.random() < Config.StressChance then
                    TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                end
            end
        end
        Wait(6)
    end
end)

-- Stress Screen Effects
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local sleep = GetEffectInterval(stress)
        if stress >= 100 then
            local ShakeIntensity = GetShakeIntensity(stress)
            local FallRepeat = math.random(2, 4)
            local RagdollTimeout = (FallRepeat * 1750)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
            --SetFlash(0, 0, 500, 3000, 500)

            if not IsPedRagdoll(ped) and IsPedOnFoot(ped) and not IsPedSwimming(ped) then
                local player = PlayerPedId()
                SetPedToRagdollWithFall(player, RagdollTimeout, RagdollTimeout, 1, GetEntityForwardVector(player) --[[@as number]], 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
            end

            Wait(500)
            for i = 1, FallRepeat, 1 do
                Wait(750)
                DoScreenFadeOut(200)
                Wait(1000)
                DoScreenFadeIn(200)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
                --SetFlash(0, 0, 200, 750, 200)
            end
        elseif stress >= Config.MinimumStress then
            local ShakeIntensity = GetShakeIntensity(stress)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
            --SetFlash(0, 0, 500, 2500, 500)
        end
        Wait(sleep)
    end
end)