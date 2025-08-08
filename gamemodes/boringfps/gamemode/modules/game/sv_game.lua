function BoringFPS.SetTurnToWait(players)
    for key, value in ipairs(players) do
        value:SetState("wait")
    end
end

function BoringFPS.SetTurnToPlay(index)
    local ply = BoringFPS_CONFIG.DirectionTurnPlayers[index]
    BoringFPS_CONFIG.CurrentPlayerTurn = index
    BoringFPS.PrintToAllPlayers(ply:GetName() .. "'s turn to play!", HUD_PRINTCENTER)
    ply:SetState("play")
    BoringFPS.StartTimerTurn()
end

function BoringFPS.StartTimerTurn()
    if (not timer.Exists("BoringFPS:TimerTurn")) then
        net.Start(BoringFPS_CONFIG.NetVar.StartChronoTurn)
        net.Broadcast()
        timer.Create("BoringFPS:TimerTurn", BoringFPS_CONFIG.Settings.LimitTimeTurn, 1, function()
            BoringFPS.EndTurn()
        end)
    end
end

function BoringFPS.EndTurn()
    timer.Remove("BoringFPS:TimerTurn")
    local ply = BoringFPS_CONFIG.DirectionTurnPlayers[BoringFPS_CONFIG.CurrentPlayerTurn]
    net.Start(BoringFPS_CONFIG.NetVar.StopChronoTurn)
    net.Broadcast()

    BoringFPS.PrintToAllPlayers(ply:GetName() .. "'s turn has ended!", HUD_PRINTCENTER)
    BoringFPS.SetTurnToWait({ply})
    timer.Create("BoringFPS:NextTurn", BoringFPS_CONFIG.Settings.TimerBetweenTurns, 1, function()
        BoringFPS.SetTurnToPlay(BoringFPS.GetNextPlayerTurn())
    end)
end

function BoringFPS.GetNextPlayerTurn()
    local currentIndex = BoringFPS_CONFIG.CurrentPlayerTurn
    local nextIndex = currentIndex + 1

    if nextIndex > #BoringFPS_CONFIG.DirectionTurnPlayers then
        nextIndex = 1
    end

    return nextIndex
end