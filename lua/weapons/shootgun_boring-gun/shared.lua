AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Base = "base_weapon_boring-gun"
SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.Category = "Boring gun"
SWEP.ViewModel = Model( "models/weapons/v_shotgun.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_shotgun.mdl" )

SWEP.ViewModelFOV = 65
SWEP.HoldType = "shotgun"
SWEP.UseHands = true

SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Pellets = 6
SWEP.SpreadAngle = 0.1
SWEP.ForceBullet = 1
SWEP.Tracer = 1

SWEP.Damage = 18
SWEP.MaxStep = 8
SWEP.MaxDash = 1
SWEP.Action = 1

function SWEP:Shoot()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    owner:LagCompensation(true)
    self:ShootBullet(self.Damage, self.Pellets, self.SpreadAngle, "self.Primary.Ammo", self.ForceBullet, self.Tracer)
    owner:LagCompensation(false)
end