AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Base = "base_weapon_boring-gun"
SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.Category = "Boring gun"
SWEP.ViewModel = Model( "models/weapons/c_shotgun.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_shotgun.mdl" )

SWEP.ViewModelFOV = 65
SWEP.HoldType = "shotgun"

SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Damage = 8
SWEP.MaxStep = 8
SWEP.MaxDash = 1
SWEP.Action = 1

SWEP.Pellets = 9
SWEP.SpreadAngle = 0.15
SWEP.ForceBullet = 100
SWEP.Tracer = 1

function SWEP:ShootBulletSpray(ply, weapon, bulletCount, spread, damage)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if bulletCount <= 0 or damage <= 0 then return end

    local shootPos = ply:GetShootPos()
    local aimDir = ply:GetAimVector()

    local function DoTrace(dir)
        local traceData = {}
        traceData.start = shootPos
        traceData.endpos = shootPos + (dir * 1000)
        traceData.filter = ply
        local tr = util.TraceLine(traceData)

        if not tr.Hit then return end

        if IsValid(tr.Entity) and tr.Entity:IsPlayer() and SERVER then
            local dmgInfo = DamageInfo()
            dmgInfo:SetAttacker(ply)
            dmgInfo:SetInflictor(weapon)
            dmgInfo:SetDamage(damage)
            dmgInfo:SetDamageType(DMG_BULLET)
            tr.Entity:TakeDamageInfo(dmgInfo)
        else
            local effectData = EffectData()
            effectData:SetOrigin(tr.HitPos)
            effectData:SetNormal(tr.HitNormal)
            effectData:SetStart( tr.StartPos )
            effectData:SetSurfaceProp( tr.SurfaceProps )
            effectData:SetEntity( tr.Entity )
            effectData:SetHitBox( tr.HitBoxBone or 0 )
            effectData:SetDamageType( DMG_BULLET )
            util.Effect("Impact", effectData)
        end
    end

    DoTrace(aimDir)

    if bulletCount > 1 then
        for i = 2, bulletCount do
            local theta = (i - 1) * (2 * math.pi / (bulletCount - 1))
            local phi = math.pi * math.random() - (math.pi / 2)

            local offset = Vector(
                math.cos(theta) * math.cos(phi),
                math.sin(theta) * math.cos(phi),
                math.sin(phi)
            ) * spread

            local dir = (aimDir + offset):GetNormalized()

            DoTrace(dir)
        end
    end
end

function SWEP:Shoot()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    owner:LagCompensation(true)
    self:ShootBullet(0, 0, 0)
    self:ShootBulletSpray(owner, self, self.Pellets, self.SpreadAngle, self.Damage)
    if SERVER then owner:EmitSound("weapons/shotgun/shotgun_fire6.wav", 75, math.random(95, 105)) end
    owner:LagCompensation(false)
end

function SWEP:ReloadAnimation(owner)
    owner:DoReloadEvent()
    self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
    local VMAnim = owner:GetViewModel()
    local NextIdle = VMAnim:SequenceDuration() / VMAnim:GetPlaybackRate() 
    timer.Simple(NextIdle, function()
        if (not IsValid(self)) then return end
        self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
    end)
end