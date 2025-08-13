function BoringFPS.DisplayHUDPlay()
    local timeLimit = BoringFPS_CONFIG.Settings.LimitTimeTurn
    local startTime = CurTime() + timeLimit
    local ply = LocalPlayer()
    local weapon = ply:GetNWEntity("WeaponGame", nil)
    local stepMax = weapon and weapon.MaxStep or 0
    local actionMax = weapon and weapon.Action or 0

    hook.Add( "HUDPaint", "HUDPaint:BoringFPS:HUDTurn", function()
        draw.DrawText( "Time left : " .. math.Round(startTime - CurTime()) + 1, "TargetID", BoringFPS_CONFIG.Vars.ScrW * 0.9, BoringFPS_CONFIG.Vars.ScrH * 0.85, Color(184, 0, 0), TEXT_ALIGN_CENTER )
        BoringFPS.DrawStepLeftHUD(BoringFPS_CONFIG.Vars.ScrW * 0.8, BoringFPS_CONFIG.Vars.ScrH * 0.9, ply:GetNWInt("StepLeft", 0), stepMax)
        BoringFPS.DrawActionLeft(BoringFPS_CONFIG.Vars.ScrW * 0.8, BoringFPS_CONFIG.Vars.ScrH * 0.95, ply:GetNWInt("Action", 0), actionMax)
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

function BoringFPS.DrawSquare(x, y, value, maxValue, squareW, squareH, xMargin)
    local maxX = BoringFPS_CONFIG.Vars.ScrW
    local startY = y
    local startX = x
    local colorSquare = Color(0, 0, 0)
    xMargin = xMargin + squareW

    for i = 1, maxValue do
        colorSquare = i > value and Color(0, 0, 0) or Color(255, 255, 255)
        draw.RoundedBox(0, startX, y, squareW, squareH, colorSquare)
        startX = startX + xMargin
        if (startX >= maxX - squareW) then
            startX = x
            startY = startY + xMargin
        end
    end
end

function BoringFPS.DrawIconHud(x, y, icon)
    surface.SetMaterial(icon)
    surface.SetDrawColor(255, 255, 255)
    surface.DrawTexturedRect(x, y - 5, 30, 30)
end

function BoringFPS.DrawActionLeft(x, y, value, maxValue)
    local squareW = 30 * (4 / maxValue)
    local squareH = 15 * (4 / maxValue)
    local startX = x + 50

    BoringFPS.DrawIconHud(x, y, BoringFPS_CONFIG.Icons.ActionLeftIcon)
    draw.DrawText(value, "TargetID", startX, y, Color(255, 255, 255), TEXT_ALIGN_CENTER)

    startX = startX + 25
    BoringFPS.DrawSquare(startX, y, value, maxValue, squareW, squareH, 20)
end

function BoringFPS.DrawStepLeftHUD(x, y, value, maxValue)
    local maxX = BoringFPS_CONFIG.Vars.ScrW
    local squareSize = 22 * (12 / maxValue)
    local startX = x + 50

    BoringFPS.DrawIconHud(x, y, BoringFPS_CONFIG.Icons.StepLeftIcon)
    draw.DrawText(value, "TargetID", startX, y, Color(255, 255, 255), TEXT_ALIGN_CENTER)

    startX = startX + 25
    BoringFPS.DrawSquare(startX, y, value, maxValue, squareSize, squareSize, 1)
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