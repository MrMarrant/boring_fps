AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Base = "base_weapon_boring-gun"
SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.Category = "Boring gun"
SWEP.ViewModel = Model( "models/weapons/v_pistol.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_pistol.mdl" )

SWEP.ViewModelFOV = 65
SWEP.HoldType = "pistol"
SWEP.UseHands = true

SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Damage = 30
SWEP.MaxStep = 10
SWEP.MaxDash = 3
SWEP.Action = 2

function SWEP:Shoot()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    owner:LagCompensation(true)
    self:ShootBullet(self.Damage, 1, 0)
    owner:LagCompensation(false)
end