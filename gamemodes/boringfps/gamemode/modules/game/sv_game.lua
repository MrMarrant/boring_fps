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
        net.Start(BoringFPS_CONFIG.NetVar.StartClientTurn)
        net.Broadcast()
        timer.Create("BoringFPS:TimerTurn", BoringFPS_CONFIG.Settings.LimitTimeTurn, 1, function()
            BoringFPS.EndTurn()
        end)
    end
end

function BoringFPS.EndTurn()
    timer.Remove("BoringFPS:TimerTurn")
    local ply = BoringFPS_CONFIG.DirectionTurnPlayers[BoringFPS_CONFIG.CurrentPlayerTurn]
    net.Start(BoringFPS_CONFIG.NetVar.StopClientTurn)
    net.Broadcast()

    BoringFPS.PrintToAllPlayers(ply:GetName() .. "'s turn has ended!", HUD_PRINTCENTER)
    BoringFPS.SetTurnToWait({ply})
    timer.Create("BoringFPS:NextTurn", BoringFPS_CONFIG.Settings.TimerBetweenTurns, 1, function()
        BoringFPS.SetTurnToPlay(BoringFPS.GetNextPlayerTurn())
    end)
end

function BoringFPS.GetNextPlayerTurn()
    local currentIndex = BoringFPS_CONFIG.CurrentPlayerTurn
    local nextIteration = 1
    local nextIndex = currentIndex

    while (nextIteration <= #BoringFPS_CONFIG.DirectionTurnPlayers) do -- We set a limit at the size of current players
        nextIndex = currentIndex + 1
        if nextIndex > #BoringFPS_CONFIG.DirectionTurnPlayers then
            nextIndex = 1
        end
        if (BoringFPS_CONFIG.DirectionTurnPlayers[nextIndex]) then
            return nextIndex -- Return the new index and exit this loop
        else
            nextIteration = nextIteration + 1
        end
    end
end

function BoringFPS.EndGame()
    -- TODO: Finir la partie -> Respawn les joueurs dans la salle d'attente -> Lancer une nouvelle partie
    BoringFPS.PrintToAllPlayers(BoringFPS_CONFIG.PlayersAlive[1]:GetName() .. "'s has won!", HUD_PRINTCENTER)
    BoringFPS.ResetParams()
    timer.Create("BoringFPS:TimerPostGame", BoringFPS_CONFIG.Settings.TimerPostGame, 1, function ()
        for key, value in ipairs(player.GetAll()) do
            value:Spawn()
            value:SetState("free")
        end
        BoringFPS.NewGame()
    end)
end