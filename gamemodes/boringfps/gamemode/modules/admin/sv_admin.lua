concommand.Add("restart_game", function(ply, cmd, args, argStr)
    if (ply:IsAdmin() or ply:IsSuperAdmin()) then
        if (BoringFPS_CONFIG.GameInProgress) then
            BoringFPS.GameFinish(true)
        else
            BoringFPS.NewGame()
        end
    end
end)

concommand.Add("skip_turn", function(ply, cmd, args, argStr)
    if (ply:IsAdmin() or ply:IsSuperAdmin()) then
        if (BoringFPS_CONFIG.GameInProgress and timer.Exists("BoringFPS:TimerTurn")) then
            BoringFPS.EndTurn()
        end
    end
end)