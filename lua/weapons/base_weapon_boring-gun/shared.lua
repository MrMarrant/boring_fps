AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Spawnable = false

SWEP.Category = "Boring gun"
SWEP.ViewModel = Model( "" )
SWEP.WorldModel = Model( "" )

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
SWEP.DrawAmmo = true

SWEP.Damage = 50
SWEP.MaxStep = 200
SWEP.MaxDash = 2

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
    if (self:Canfire()) then
        self:Shoot()
        self:TakePrimaryAmmo(1)
        -- TODO : Retirer une action au joueur
    end
end

function SWEP:SecondaryAttack()
end

function SWEP:Canfire()
    --! Vérifier sur le joueur s'il a encore une action
    return (self:Clip1() > 0)
end

function SWEP:Shoot()
end

function SWEP:Reload()
    -- TODO : Vérifier sur le joueur s'il a encore une action
    if self:Clip1() < self:GetMaxClip1() then
        self:DefaultReload(ACT_VM_RELOAD)
        self:SetClip1(self:GetMaxClip1())
    end
end