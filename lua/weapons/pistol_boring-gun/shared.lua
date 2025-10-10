AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Base = "base_weapon_boring-gun"
SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.Category = "Boring gun"
SWEP.ViewModel = Model( "models/weapons/c_pistol.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_pistol.mdl" )

SWEP.ViewModelFOV = 65
SWEP.HoldType = "pistol"

SWEP.Primary.ClipSize = 4
SWEP.Primary.DefaultClip = 4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.WeaponName = "pistol"

SWEP.LocationStart = Vector(0,0,0)

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
    hook.Add("PlayerTurnStart", "BoringFPS:PlayerTurnStart_Pistol_"..self:EntIndex(), function(ply)
        if IsValid(ply) and ply == self:GetOwner() then
            self.LocationStart = ply:GetPos()
        end
    end)
end

function SWEP:OnRemove()
    hook.Remove("PlayerTurnStart", "BoringFPS:PlayerTurnStart_Pistol_"..self:EntIndex())
end

function SWEP:Shoot()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    owner:LagCompensation(true)
    self:ShootBullet(self.Damage, 1, 0)
    if SERVER then owner:EmitSound("weapons/pistol/pistol_fire2.wav", 75, math.random(95, 105)) end
    owner:LagCompensation(false)
end

function SWEP:SecondaryShoot()
    local owner = self:GetOwner()
    owner:SetPos(self.LocationStart)
    owner:SetAction(owner:GetNWInt("Action", 0) - 1, true)
end