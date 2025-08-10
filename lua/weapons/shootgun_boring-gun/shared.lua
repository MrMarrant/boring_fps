AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Spawnable = true
SWEP.ViewModel = Model( "" )
SWEP.WorldModel = Model( "" )

SWEP.HoldType = "shotgun"
SWEP.Damage = 15          -- dégâts par projectile
SWEP.Pellets = 8          -- nombre de projectiles par tir
SWEP.SpreadAngle = 5      -- dispersion en degrés
SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = 5

SWEP.MaxStep = 100
SWEP.MaxDash = 2

function SWEP:Shoot()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    owner:LagCompensation(true)

    for i = 1, self.Pellets do
        local dir = owner:GetAimVector()

        local spread = VectorRand() * math.tan(math.rad(self.SpreadAngle))
        dir = (dir + spread):GetNormalized()

        local traceData = {}
        traceData.start = owner:GetShootPos()
        traceData.endpos = traceData.start + dir * 100000 --? Distance is infinite
        traceData.filter = owner

        local trace = util.TraceLine(traceData)

        if trace.Hit and IsValid(trace.Entity) and trace.Entity:IsPlayer() then
            local dmginfo = DamageInfo()
            dmginfo:SetAttacker(owner)
            dmginfo:SetInflictor(self)
            dmginfo:SetDamage(self.Damage)
            dmginfo:SetDamageType(DMG_BUCKSHOT)
            trace.Entity:TakeDamageInfo(dmginfo)
        end
    end

    owner:LagCompensation(false)
end