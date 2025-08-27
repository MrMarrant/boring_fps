include("shared.lua")

function ENT:Initialize()
	self.IconEnt = Material(self.IconsClass[self:GetNWString( "classgun", "pistol" )])
end

function ENT:Draw()
    self:DrawModel()

    local ang = EyeAngles()
    ang = Angle( 0, ang.y, 0 )
    ang:RotateAroundAxis( ang:Up(), -90 )
    ang:RotateAroundAxis( ang:Forward(), 90 )

    local basePos = self:GetPos()
    basePos.z = basePos.z + 40 * self:GetModelScale()

    local cycle = math.sin(CurTime() * (2 * math.pi / 3))
    local offset = cycle * 2
    local pos = basePos + Vector(0, 0, offset)

    cam.Start3D2D(pos, ang, 0.1)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(self.IconEnt)
        local size = 64
        surface.DrawTexturedRect(-size/2, -size/2, size, size)
    cam.End3D2D()
end