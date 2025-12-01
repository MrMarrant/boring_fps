if (engine.ActiveGamemode() ~= "boringfps") then return end

AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel(BoringFPS_CONFIG.Models.Rocket)
	self:RebuildPhysics()
	self.SpawnTime = CurTime() + self.DurationRocket
    self.StartPos = self:GetPos()
    self.MinDamage = self.MaxDamage * self.MinDamageMultiplier
end

-- Initialise the physic of the entity
function ENT:RebuildPhysics()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
    self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableGravity(false)
        phys:EnableDrag(false)
        phys:SetMass(2)
        phys:Wake()
    end
end

function ENT:PhysicsCollide( data, physobj )
    self:Explode(data.HitPos, data.HitEntity)
end

function ENT:Explode(hitPos, hitEntity)
    if self.Exploded then return end
    self.Exploded = true

    local effect = EffectData()
    effect:SetOrigin(hitPos)
    util.Effect("Explosion", effect, true, true)

    for _, ent in ipairs(ents.FindInSphere(hitPos, self.ExplosionRadius)) do
        if ent:IsPlayer() or ent:IsNPC() then
            local dist = math.Clamp(self.StartPos:Distance(ent:GetPos()), 0, self.DistanceMax)
            local t = dist / self.DistanceMax
            local maxDamage = (IsValid(hitEntity) and hitEntity == ent) and self.MaxDamage or self.MaxDamage * self.SplashDamageMultiplier
            local dmg = dist > self.DistanceMin and Lerp(1 - t, self.MinDamage, maxDamage) or maxDamage
            dmg = self:GetOwner() == ent and dmg * self.SelfDamageMultiplier or dmg --? reduce self damage

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