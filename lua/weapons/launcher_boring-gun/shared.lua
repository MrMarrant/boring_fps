AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Base = "base_weapon_boring-gun"
SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.Category = "Boring gun"
SWEP.ViewModel = Model( "models/weapons/v_rpg.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_rocket_launcher.mdl" )

SWEP.ViewModelFOV = 65
SWEP.HoldType = "rpg"
SWEP.UseHands = true

SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Damage = 100
SWEP.MaxStep = 6
SWEP.MaxDash = 1
SWEP.Action = 1

SWEP.VelocityRocket = 4000

function SWEP:Shoot()
    local owner = self:GetOwner()
    owner:SetAnimation( PLAYER_ATTACK1 )
    if not IsValid(owner) or CLIENT then return end

    if not IsValid(owner) then return end

    local rocket = ents.Create("rocket_boring-gun")
    if not IsValid(rocket) then return end

    local muzzlePos = owner:GetShootPos()
    local aimDir = owner:GetAimVector()

    rocket:SetPos(muzzlePos + aimDir * 20)
    rocket:SetAngles(aimDir:Angle())
    rocket:SetOwner(owner)
    rocket.MaxDamage = self.Damage
    rocket:Spawn()

    local phys = rocket:GetPhysicsObject()
    if IsValid(phys) then
        phys:SetVelocity(aimDir * self.VelocityRocket)
    end
    
    owner:SetVelocity( owner:GetForward() * -700 )
    owner:EmitSound("weapons/rpg/rocketfire1.wav")
end