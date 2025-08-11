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

SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Pellets = 8          -- nombre de projectiles par tir
SWEP.SpreadAngle = 0.08      -- dispersion en degrés
SWEP.Damage = 15
SWEP.MaxStep = 10
SWEP.MaxDash = 2

function SWEP:Shoot()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    owner:LagCompensation(true)
    self:ShootBullet(self.Damage, self.Pellets, self.SpreadAngle)
    owner:LagCompensation(false)
end