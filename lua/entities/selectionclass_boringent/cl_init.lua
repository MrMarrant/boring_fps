include("shared.lua")

local size = 120

function ENT:Draw()
    self:DrawModel()

    local ang = EyeAngles()
    ang = Angle( 0, ang.y, 0 )
    ang:RotateAroundAxis( ang:Up(), -90 )
    ang:RotateAroundAxis( ang:Forward(), 90 )

    local basePos = self:GetPos()
    basePos.z = basePos.z + 70 * self:GetModelScale()

    local cycle = math.sin(CurTime() * (2 * math.pi / 3))
    local offset = cycle * 0.1
    local pos = basePos + Vector(-17, 0, offset)

    cam.Start3D2D(pos, Angle(0, -90, 82), 0.1)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial( BoringFPS_CONFIG.Settings.IconsClass[self:GetNWString( "classgun", "pistol" )] )
        surface.DrawTexturedRect(-size/2, -size/2, size, size)
        draw.DrawText(string.upper(self:GetNWString( "classgun", "pistol" )), "NickAnton", 0, 60, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    cam.End3D2D()
end