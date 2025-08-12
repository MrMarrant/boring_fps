function BoringFPS.DisplayHUDPlay()
    local timeLimit = BoringFPS_CONFIG.Settings.LimitTimeTurn
    local startTime = CurTime() + timeLimit
    local ply = LocalPlayer()

    hook.Add( "HUDPaint", "HUDPaint:BoringFPS:HUDTurn", function()
        draw.DrawText( "Time left : " .. math.Round(startTime - CurTime()) + 1, "TargetID", BoringFPS_CONFIG.Vars.ScrW * 0.9, BoringFPS_CONFIG.Vars.ScrH * 0.85, Color(184, 0, 0), TEXT_ALIGN_CENTER )
        draw.DrawText( "Step left : " .. ply:GetNWInt("StepLeft", 0), "TargetID", BoringFPS_CONFIG.Vars.ScrW * 0.9, BoringFPS_CONFIG.Vars.ScrH * 0.9, Color(28, 0, 184), TEXT_ALIGN_CENTER )
        draw.DrawText( "Action left : " .. ply:GetNWInt("Action", 0), "TargetID", BoringFPS_CONFIG.Vars.ScrW * 0.9, BoringFPS_CONFIG.Vars.ScrH * 0.95, Color(182, 155, 2), TEXT_ALIGN_CENTER )
    end )
end

function BoringFPS.DisplayHUDWait()
    local ply = LocalPlayer()

    hook.Add( "HUDPaint", "HUDPaint:BoringFPS:HUDTurn", function()
        draw.DrawText( "Dash left : " .. ply:GetNWInt("Dash", 0), "TargetID", BoringFPS_CONFIG.Vars.ScrW * 0.9, BoringFPS_CONFIG.Vars.ScrH * 0.95, Color(116, 0, 131), TEXT_ALIGN_CENTER )
    end )
end

function BoringFPS.StopHudTurn()
    hook.Remove( "HUDPaint", "HUDPaint:BoringFPS:HUDTurn" )
end

function BoringFPS.PlaySound(sound, loop)
    local ply = LocalPlayer()
    if (loop) then
        ply:StartLoopingSound(sound)
    else
        ply:EmitSound(sound, 40)
    end
end

function BoringFPS.StopSound(sound)
    local ply = LocalPlayer()
    ply:StopSound(sound)
end

function BoringFPS.StopSound(sound)
    local ply = LocalPlayer()
    ply:StopSound(sound)
end

-- Net Receive
net.Receive(BoringFPS_CONFIG.NetVar.StartClientWait, function()
    BoringFPS.DisplayHUDWait()
end)

net.Receive(BoringFPS_CONFIG.NetVar.StartClientPlay, function()
    BoringFPS.DisplayHUDPlay()
end)

net.Receive(BoringFPS_CONFIG.NetVar.StopClientTurn, function()
    BoringFPS.StopHudTurn()
end)

net.Receive(BoringFPS_CONFIG.NetVar.PlayClientSound, function()
    local soundToPlay = net.ReadString()
    local isLoop = net.ReadBool()
    BoringFPS.PlaySound(soundToPlay, isLoop)
end)

net.Receive(BoringFPS_CONFIG.NetVar.StopPlayClientSound, function()
    local soundToStop = net.ReadString()
    BoringFPS.StopSound(soundToStop)
end)