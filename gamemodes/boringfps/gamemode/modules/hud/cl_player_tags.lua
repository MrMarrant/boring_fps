-- Vars
local rectW, rectH = 300, 100     -- Size box
local cornerRadius = 12          -- Roundness level
local margin = 50                -- Internal margin
local iconMat = BoringFPS_CONFIG.Icons.HeartFillIcon -- Icon hp
local iconSize = 40              -- Icon size

hook.Add( "PostPlayerDraw", "PostPlayerDraw:BoringFPS:PaintPlayerTags", function(ply)
	if ( ply == LocalPlayer() or not ply:Alive() ) then return end

    local colorPlayers = BoringFPS_CONFIG.Vars.ColorBox -- Color box for each player
    local colorBox = colorPlayers[ply] or Color(0, 0, 0)
	local pos = ply:GetPos() + ply:GetUp() * ( ply:OBBMaxs().z + 8 )
	local angle = ( pos - EyePos() ):GetNormalized():Angle()
	angle = Angle( 0, angle.y, 0 )
	angle:RotateAroundAxis( angle:Up(), -90 )
	angle:RotateAroundAxis( angle:Forward(), 90 )

	cam.Start3D2D( pos, angle, 0.05 )

    local scrW, scrH = BoringFPS_CONFIG.Vars.ScrW, BoringFPS_CONFIG.Vars.ScrH
    local rectX = -rectW / 2
    local rectY = -rectH / 2

    BoringFPS.DrawRoundedOutlinedBox(cornerRadius, rectX, rectY, rectW, rectH, 2, colorBox, color_white)

    local centerY = rectY + rectH / 2
    local playerName = BoringFPS.TruncatedText(ply:Nick(), "DermaLarge", rectW - margin * 2.7 - iconSize)

    draw.SimpleText(playerName, "DermaLarge", rectX + margin, centerY, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    local rightX = rectX + rectW - margin
    local health = math.Clamp(ply:Health(), 0, ply:GetMaxHealth())

    surface.SetFont("DermaLarge")
    local numW, numH = surface.GetTextSize(tostring(health))
    draw.SimpleText(health, "DermaLarge", rightX, centerY, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

    local iconX = rightX - numW - 5 - iconSize

    surface.SetMaterial(iconMat)
    surface.SetDrawColor(Color(255, 255, 255))
    surface.DrawTexturedRect(iconX, centerY - iconSize / 2, iconSize, iconSize)
	cam.End3D2D()
end )