function BoringFPS.DisplayHUDPlay()
    local timeLimit = BoringFPS_CONFIG.Settings.LimitTimeTurn
    local startTime = CurTime() + timeLimit
    local ply = LocalPlayer()
    local weapon = ply:GetNWEntity("WeaponGame", nil)
    local stepMax = weapon and weapon.MaxStep or 0
    local actionMax = weapon and weapon.Action or 0

    hook.Add( "HUDPaint", "HUDPaint:BoringFPS:HUDTurn", function()
        BoringFPS.DrawTimerLeft(BoringFPS_CONFIG.Vars.ScrW * 0.5, BoringFPS_CONFIG.Vars.ScrH * 0.08, math.Round(startTime - CurTime()) + 1)
        BoringFPS.DrawStepLeftHUD(BoringFPS_CONFIG.Vars.ScrW * 0.8, BoringFPS_CONFIG.Vars.ScrH * 0.9, ply:GetNWInt("StepLeft", 0), stepMax)
        BoringFPS.DrawActionLeft(BoringFPS_CONFIG.Vars.ScrW * 0.8, BoringFPS_CONFIG.Vars.ScrH * 0.95, ply:GetNWInt("Action", 0), actionMax)
    end )
end

function BoringFPS.DisplayHUDWait()
    local ply = LocalPlayer()

    hook.Add( "HUDPaint", "HUDPaint:BoringFPS:HUDTurn", function()
        draw.DrawText( "Dash left : " .. ply:GetNWInt("Dash", 0), "HudBoringFPS", BoringFPS_CONFIG.Vars.ScrW * 0.9, BoringFPS_CONFIG.Vars.ScrH * 0.95, Color(116, 0, 131), TEXT_ALIGN_CENTER )
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

function BoringFPS.DrawTimerLeft(x, y, timeLeft)
    surface.SetDrawColor( 255, 255, 255)
	draw.Circle( x, y, 50, 100 )
    surface.SetDrawColor( 0, 0, 0)
	draw.Circle( x, y, 45, 100 )
    draw.DrawText(timeLeft, "HudTimerLeft", x, y - 45, Color(255, 255, 255), TEXT_ALIGN_CENTER)
end

function BoringFPS.DrawActionLeft(x, y, value, maxValue)
    local squareW = 30 * (4 / maxValue)
    local squareH = 15 * (4 / maxValue)
    local startX = x + 50

    BoringFPS.DrawIconHud(x, y, BoringFPS_CONFIG.Icons.ActionLeftIcon)
    draw.DrawText(value, "HudBoringFPS", startX, y - 10, Color(255, 255, 255), TEXT_ALIGN_CENTER)

    startX = startX + 25
    BoringFPS.DrawSquare(startX, y, value, maxValue, squareW, squareH, 20)
end

function BoringFPS.DrawStepLeftHUD(x, y, value, maxValue)
    local maxX = BoringFPS_CONFIG.Vars.ScrW
    local squareSize = 22 * (12 / maxValue)
    local startX = x + 50

    BoringFPS.DrawIconHud(x, y, BoringFPS_CONFIG.Icons.StepLeftIcon)
    draw.DrawText(value, "HudBoringFPS", startX, y - 10, Color(255, 255, 255), TEXT_ALIGN_CENTER)

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

function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
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