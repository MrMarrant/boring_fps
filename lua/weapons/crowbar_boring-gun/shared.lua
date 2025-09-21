AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Base = "base_weapon_boring-gun"
SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.Category = "Boring gun"
SWEP.ViewModel = Model( "models/weapons/c_crowbar.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_crowbar.mdl" )

SWEP.ViewModelFOV = 65
SWEP.HoldType = "melee"

SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.RangeAttack = 100

SWEP.Damage = 20
SWEP.MaxStep = 18
SWEP.MaxDash = 2
SWEP.Action = 2

function SWEP:Shoot()
    local owner = self:GetOwner()
    self:SendWeaponAnim( ACT_VM_MISSCENTER )
    owner:SetAnimation( PLAYER_ATTACK1 )
    if not IsValid(owner) or CLIENT then return end

    local dir = owner:GetAimVector()

    local traceData = {}
    traceData.start = owner:GetShootPos()
    traceData.endpos = traceData.start + dir * self.RangeAttack
    traceData.filter = owner

    local trace = util.TraceLine(traceData)

    if trace.Hit and IsValid(trace.Entity) and trace.Entity:IsPlayer() then
        local dmginfo = DamageInfo()
        dmginfo:SetAttacker(owner or self)
        dmginfo:SetInflictor(owner or self)
        dmginfo:SetDamage(self.Damage)
        dmginfo:SetDamageType(DMG_CLUB)
        trace.Entity:TakeDamageInfo(dmginfo)
        owner:EmitSound("weapons/crowbar/crowbar_impact" .. math.random(1, 2) .. ".wav")
    else
        owner:EmitSound("npc/zombie/claw_miss1.wav")
    end
end

function SWEP:Reload()
end

function SWEP:CanFire()
    return (self:GetOwner():CanUseAction())
end