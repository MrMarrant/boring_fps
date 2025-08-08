function BoringFPS.SetTurnToWait(players)
    for key, value in ipairs(players) do
        value:SetState("wait")
    end
end

function BoringFPS.SetTurnToPlay(ply)
    BoringFPS_CONFIG.CurrentPlayerTurn = ply
    BoringFPS.PrintToAllPlayers(ply:GetName() .. "'s turn to play!", HUD_PRINTCENTER)
    ply:SetState("play")
end