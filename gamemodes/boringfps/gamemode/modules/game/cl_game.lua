function BoringFPS.DisplayHUDTurn()
    local timeLimit = BoringFPS_CONFIG.Settings.LimitTimeTurn
    local startTime = CurTime() + timeLimit
    local ply = LocalPlayer()

    hook.Add( "HUDPaint", "HUDPaint:BoringFPS:HUDTurn", function()
        draw.DrawText( "Time left : " .. math.Round(startTime - CurTime()) + 1, "TargetID", BoringFPS_CONFIG.Vars.ScrW * 0.9, BoringFPS_CONFIG.Vars.ScrH * 0.85, Color(184, 0, 0), TEXT_ALIGN_CENTER )
        draw.DrawText( "Step left : " .. ply:GetNWInt("StepLeft"), "TargetID", BoringFPS_CONFIG.Vars.ScrW * 0.9, BoringFPS_CONFIG.Vars.ScrH * 0.9, Color(28, 0, 184), TEXT_ALIGN_CENTER )
        draw.DrawText( "Action left : " .. ply:GetNWInt("Action"), "TargetID", BoringFPS_CONFIG.Vars.ScrW * 0.9, BoringFPS_CONFIG.Vars.ScrH * 0.95, Color(182, 155, 2), TEXT_ALIGN_CENTER )
    end )
end

function BoringFPS.StopHudTurn()
    hook.Remove( "HUDPaint", "HUDPaint:BoringFPS:HUDTurn" )
end


-- Net Receive
net.Receive(BoringFPS_CONFIG.NetVar.StartClientTurn, function()
    BoringFPS.DisplayHUDTurn()
end)

net.Receive(BoringFPS_CONFIG.NetVar.StopClientTurn, function()
    BoringFPS.StopHudTurn()
end)