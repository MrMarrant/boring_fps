if (engine.ActiveGamemode() != "boringfps") then return end

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
SWEP.UseHands = false

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.WeaponName = "base"
SWEP.WeaponSetting = {}
SWEP.Damage = 0
SWEP.MaxStep = 0
SWEP.MaxDash = 0
SWEP.Action = 0
SWEP.WalkSpeed = 0
SWEP.RunSpeed = 0

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:SetWeaponStats()
end

function SWEP:SetWeaponStats()
    self.WeaponSetting = BoringFPS_CONFIG.Settings.Weapons[self.WeaponName]
    self.Damage = self.WeaponSetting.Damage or 10
    self.MaxStep = self.WeaponSetting.MaxStep or 10
    self.MaxDash = self.WeaponSetting.MaxDash or 2
    self.Action = self.WeaponSetting.Action or 1
    self.WalkSpeed = self.WeaponSetting.WalkSpeed
    self.RunSpeed = self.WeaponSetting.RunSpeed
end

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()
    if self:CanFire() and IsValid(owner) then
        self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
        self:Shoot()
        self:TakePrimaryAmmo(1)
        owner:SetAction(owner:GetNWInt("Action", 0) - 1, true)
    end
end

function SWEP:SecondaryAttack()
    if (self:GetOwner():CanUseAction()) then
        self:SecondaryShoot()
    elseif self:CanDash() and SERVER then
        local owner = self:GetOwner()
        owner:SetVelocity( BoringFPS.GetWantedMoveDirection(owner) * 1000 )
        owner:EmitSound("weapons/stunstick/spark" .. math.random(1, 3) .. ".wav", 75, math.random(90, 110))
        owner:SetNWInt("Dash", owner:GetNWInt("Dash", 0) - 1)
        hook.Call("OnNewDataPlayer", nil, owner, "dash_done")
    end
end

function SWEP:Shoot()
end

function SWEP:SecondaryShoot()
end

function SWEP:Reload()
    local owner = self:GetOwner()
    if self:CanReload() and IsValid(owner) then
        self:ReloadAnimation(owner)
        self:SetClip1(self:GetMaxClip1())
        owner:SetAction(owner:GetNWInt("Action", 0) - 1, true)
        if SERVER then owner:EmitSound("weapons/smg1/smg1_reload.wav") end
    end
end

function SWEP:CanFire()
    return (self:Clip1() > 0 and self:GetOwner():CanUseAction())
end

function SWEP:CanReload()
    return (self:Clip1() < self:GetMaxClip1() and self:GetOwner():CanUseAction())
end

function SWEP:CanDash()
    local owner = self:GetOwner()
    return (owner:GetNWInt("Dash", 0) > 0 and owner:GetNWString("State", "") == "wait")
end

function SWEP:ReloadAnimation(owner)
    owner:DoReloadEvent()
    self:SendWeaponAnim(ACT_VM_RELOAD)
end