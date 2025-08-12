AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel(BoringFPS_CONFIG.Models.Rocket)
	self:RebuildPhysics()
	self.SpawnTime = CurTime() + self.DurationRocket
end

-- Initialise the physic of the entity
function ENT:RebuildPhysics()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
end

function ENT:PhysicsCollide( data, physobj )
    self:Explode(data.HitPos)
end

function ENT:Explode(hitPos)
    if self.Exploded then return end
    self.Exploded = true

    local effect = EffectData()
    effect:SetOrigin(hitPos)
    util.Effect("Explosion", effect, true, true)

    for _, ent in ipairs(ents.FindInSphere(hitPos, self.ExplosionRadius)) do
        if ent:IsPlayer() or ent:IsNPC() then
            local dist = hitPos:Distance(ent:GetPos())
            local dmg = math.Clamp(self.MaxDamage * (1 - dist / self.ExplosionRadius), 0, self.MaxDamage)

            local dmginfo = DamageInfo()
            dmginfo:SetDamage(dmg)
            dmginfo:SetDamageType(DMG_BLAST)
            dmginfo:SetAttacker(self:GetOwner() or self)
            dmginfo:SetInflictor(self:GetOwner() or self)
            dmginfo:SetDamageForce((ent:GetPos() - hitPos):GetNormalized() * dmg * self.DamageForce)

            ent:TakeDamageInfo(dmginfo)
        end
    end

    self:Remove()
end

function ENT:Think()
    if self.SpawnTime - CurTime() <= 0 then
        self:Explode(self:GetPos())
    end
end