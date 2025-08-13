function BoringFPS.DisplayHUDPlay()
    local timeLimit = BoringFPS_CONFIG.Settings.LimitTimeTurn
    local startTime = CurTime() + timeLimit
    local ply = LocalPlayer()
    local weapon = ply:GetNWEntity("WeaponGame", nil)
    local stepMax = weapon and weapon.MaxStep or 0

    hook.Add( "HUDPaint", "HUDPaint:BoringFPS:HUDTurn", function()
        draw.DrawText( "Time left : " .. math.Round(startTime - CurTime()) + 1, "TargetID", BoringFPS_CONFIG.Vars.ScrW * 0.9, BoringFPS_CONFIG.Vars.ScrH * 0.85, Color(184, 0, 0), TEXT_ALIGN_CENTER )
        BoringFPS.DrawStepLeftHUD(BoringFPS_CONFIG.Vars.ScrW * 0.8, BoringFPS_CONFIG.Vars.ScrH * 0.9, ply:GetNWInt("StepLeft", 0), stepMax)
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

function BoringFPS.DrawStepLeftHUD(x, y, value, maxValue)
    local maxX = BoringFPS_CONFIG.Vars.ScrW
    local squareSize = 22 * (12 / maxValue)
    local xMargin = squareSize + 2
    local squareUsed = math.Clamp(maxValue - value, 0, maxValue)
    surface.SetMaterial(BoringFPS_CONFIG.Icons.StepLeftIcon)
    surface.SetDrawColor(255, 255, 255)
    surface.DrawTexturedRect(x, y - 10, 50, 50)

    local startX = x + 65

    draw.DrawText(value, "TargetID", startX, y, Color(255, 255, 255), TEXT_ALIGN_CENTER )

    startX = startX + 25
    local startSquare = startX

    for i = 1, maxValue do
        local colorSquare = i > value and Color(0, 0, 0) or Color(255, 255, 255)
        draw.RoundedBox(0, startX, y, squareSize, squareSize, colorSquare)
        startX = startX + xMargin
        if (startX >= maxX - squareSize) then
            startX = startSquare
            y = y + xMargin
        end
    end
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