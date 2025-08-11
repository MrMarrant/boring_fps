function BoringFPS.SetTurnToWait(players)
    for key, value in ipairs(players) do
        value:SetState("wait")
    end
end

function BoringFPS.SetTurnToPlay(index)
    local ply = BoringFPS_CONFIG.DirectionTurnPlayers[index]
    BoringFPS_CONFIG.CurrentIndexDirectionTurn = index
    BoringFPS_CONFIG.CurrentPlayerTurn = ply
    BoringFPS.PrintToAllPlayers(ply:GetName() .. "'s turn to play!", HUD_PRINTCENTER)
    ply:SetState("play")
    BoringFPS.StartTimerTurn()
end

function BoringFPS.StartTimerTurn()
    if (not timer.Exists("BoringFPS:TimerTurn")) then
        net.Start(BoringFPS_CONFIG.NetVar.StartClientTurn)
        net.Send(BoringFPS_CONFIG.CurrentPlayerTurn)
        timer.Create("BoringFPS:TimerTurn", BoringFPS_CONFIG.Settings.LimitTimeTurn, 1, function()
            BoringFPS.EndTurn()
        end)
    end
end

function BoringFPS.EndTurn()
    timer.Remove("BoringFPS:TimerTurn")
    local ply = BoringFPS_CONFIG.CurrentPlayerTurn
    if (IsValid(ply)) then
        net.Start(BoringFPS_CONFIG.NetVar.StopClientTurn)
        net.Send(ply)

        BoringFPS.PrintToAllPlayers(ply:GetName() .. "'s turn has ended!", HUD_PRINTCENTER)
        BoringFPS.SetTurnToWait({ply})
    else
        BoringFPS.PrintToAllPlayers("Turn has ended!", HUD_PRINTCENTER)
    end
    timer.Create("BoringFPS:NextTurn", BoringFPS_CONFIG.Settings.TimerBetweenTurns, 1, function()
        BoringFPS.SetTurnToPlay(BoringFPS.GetNextPlayerTurn())
    end)
end

function BoringFPS.GetNextPlayerTurn()
    local nextIndex = BoringFPS_CONFIG.CurrentIndexDirectionTurn
    local sizeTable = BoringFPS_CONFIG.LastIndexDirectionTurn

    for i = 1, sizeTable do
        nextIndex = nextIndex + 1
        if nextIndex > sizeTable then
            nextIndex = 1
        end
        if (BoringFPS_CONFIG.DirectionTurnPlayers[nextIndex]) then
            return nextIndex -- Return the new index and exit this loop
        end
    end
    return -1
end

function BoringFPS.EndGame()
    local winner = BoringFPS_CONFIG.PlayersAlive[1]
    BoringFPS.PrintToAllPlayers(winner:GetName() .. "'s has won!", HUD_PRINTCENTER)
    winner:SetState("free")
    BoringFPS.ResetParams()
    timer.Create("BoringFPS:TimerPostGame", BoringFPS_CONFIG.Settings.TimerPostGame, 1, function ()
        for key, value in ipairs(player.GetAll()) do
            value:Spawn()
            value:SetState("free")
        end
        BoringFPS.NewGame()
    end)
end