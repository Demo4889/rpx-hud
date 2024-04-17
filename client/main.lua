RegisterCommand("hud", function(source, args, rawCommand)
    if not LocalPlayer.state.isLoggedIn then return end
    LocalPlayer.state.UIHidden = not LocalPlayer.state.UIHidden
    if LocalPlayer.state.UIHidden then
        lib.notify({title = "HUD Disabled!", type = "error"})
        DisplayRadar(false)
    else
        lib.notify({title = "HUD Enabled!", type = "success"})
        DisplayRadar(true)
    end
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
                drunk = LocalPlayer.state.metadata['drunk'],
                onHorse = mounted,
                horsehealth = horsehealth,
                horsestamina = horsestam,
                stamina = stamina,
                talking = talking,
                voice = voice,
                youhavemail = false,
            })
        else
            SendNUIMessage({
                action = 'hudtick',
                show = false,
            })
        end
    end
end)