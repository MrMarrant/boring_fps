AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Base = "weapon_base"
SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Spawnable = false

SWEP.Category = "Boring gun"
SWEP.ViewModel = Model( "models/weapons/v_pistol.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_pistol.mdl" )

SWEP.ViewModelFOV = 65
SWEP.HoldType = "pistol"
SWEP.UseHands = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Damage = 50
SWEP.MaxStep = 10
SWEP.MaxDash = 2
SWEP.Action = 1

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()
    if self:CanFire() and IsValid(owner) then
        self:Shoot()
        self:TakePrimaryAmmo(1)
        owner:SetNWInt("Action", owner:GetNWInt("Action", 0) - 1)
    end
end

function SWEP:SecondaryAttack()
end

function SWEP:Shoot()
end

function SWEP:Reload()
    local owner = self:GetOwner()
    if self:CanReload() and IsValid(owner) then
        self:DefaultReload(ACT_VM_RELOAD)
        self:SetClip1(self:GetMaxClip1())
        owner:SetNWInt("Action", owner:GetNWInt("Action", 0) - 1)
    end
end

function SWEP:CanFire()
    return (self:Clip1() > 0 and self:GetOwner():CanUseAction())
end

function SWEP:CanReload()
    return (self:Clip1() < self:GetMaxClip1() and self:GetOwner():CanUseAction())
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end