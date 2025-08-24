function BoringFPS.SetTurnToWait(players)
    for key, value in ipairs(players) do
        value:SetState("wait")
    end
end

function BoringFPS.SetTurnToPlay(index)
    local ply = BoringFPS_CONFIG.DirectionTurnPlayers[index]
    SetGlobalInt("CurrentIndexDirectionTurn", index)
    BoringFPS_CONFIG.CurrentPlayerTurn = ply
    PrintMessage(HUD_PRINTTALK, ply:GetName() .. "'s turn to play!")
    ply:SetState("play")
    BoringFPS.StartTimerTurn()
end

function BoringFPS.StartTimerTurn()
    if (not timer.Exists("BoringFPS:TimerTurn")) then
        timer.Create("BoringFPS:TimerTurn", BoringFPS_CONFIG.Settings.LimitTimeTurn, 1, function()
            BoringFPS.EndTurn()
        end)
    end
end

function BoringFPS.EndTurn()
    timer.Remove("BoringFPS:TimerTurn")
    local ply = BoringFPS_CONFIG.CurrentPlayerTurn
    if (IsValid(ply)) then
        PrintMessage(HUD_PRINTTALK, ply:GetName() .. "'s turn has ended!")
        BoringFPS.SetTurnToWait({ply})
    else
        PrintMessage(HUD_PRINTTALK, "Turn has ended!")
    end
    timer.Create("BoringFPS:NextTurn", BoringFPS_CONFIG.Settings.TimerBetweenTurns, 1, function()
        BoringFPS.SetTurnToPlay(BoringFPS.GetNextPlayerTurn())
    end)
end

function BoringFPS.GetNextPlayerTurn()
    local nextIndex = GetGlobalInt("CurrentIndexDirectionTurn", 0)
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
    PrintMessage(HUD_PRINTTALK, winner:GetName() .. "'s has won!")
    BoringFPS.PlaySound(BoringFPS_CONFIG.Sounds.WinGame)
    winner:SetState("free")
    net.Start(BoringFPS_CONFIG.NetVar.EndGame)
    net.WriteString(winner:GetName())
    net.Broadcast()
    BoringFPS.ResetParams()
    timer.Create("BoringFPS:TimerPostGame", BoringFPS_CONFIG.Settings.TimerPostGame, 1, function ()
        for key, value in ipairs(player.GetAll()) do
            value:UnSpectate()
            value:Spawn()
            value:SetState("free")
            value:SetNWInt("NumberTurn", -1)
            value:SetNWInt("StepLeft", -1)
            value:SetNWEntity( "WeaponGame", nil )
            value:SetNWInt("Dash", -1)
            value:StripWeapons()
        end
        BoringFPS.StopSound(BoringFPS_CONFIG.CurrentMusic)
        BoringFPS.NewGame()
    end)
end

function BoringFPS.PlaySound(sound, loop, ply)
    loop = loop or false
    net.Start(BoringFPS_CONFIG.NetVar.PlayClientSound)
    net.WriteString(sound)
    net.WriteBool(loop)
    if (ply) then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

function BoringFPS.StopSound(sound, ply)
    net.Start(BoringFPS_CONFIG.NetVar.StopPlayClientSound)
    net.WriteString(sound)
    if (ply) then
        net.Send(ply)
    else
        net.Broadcast()
    end
end