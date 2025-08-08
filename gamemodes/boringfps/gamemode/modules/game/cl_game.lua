function BoringFPS.StartChronoTurn()
    print("Chrono turn started")
    local timeLimit = BoringFPS_CONFIG.Settings.LimitTimeTurn
    local startTime = CurTime() + timeLimit

    hook.Add( "HUDPaint", "HUDPaint:ChronoTurn", function()
        draw.DrawText( "Time left : " .. math.Round(startTime - CurTime()), "TargetID", BoringFPS_CONFIG.Vars.ScrW * 0.9, BoringFPS_CONFIG.Vars.ScrH * 0.9, Color(184, 0, 0), TEXT_ALIGN_CENTER )
    end )
end

function BoringFPS.StopChronoTurn()
    hook.Remove( "HUDPaint", "HUDPaint:ChronoTurn" )
end


-- Net Receive
net.Receive(BoringFPS_CONFIG.NetVar.StartChronoTurn, function()
    BoringFPS.StartChronoTurn()
end)

net.Receive(BoringFPS_CONFIG.NetVar.StopChronoTurn, function()
    BoringFPS.StopChronoTurn()
end)