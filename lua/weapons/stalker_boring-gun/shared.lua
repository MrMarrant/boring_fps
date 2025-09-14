AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Base = "base_weapon_boring-gun"
SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.Category = "Boring gun"
SWEP.ViewModel = Model( "" )
SWEP.WorldModel = Model( "" ) -- TODO : Model de revolver

SWEP.ViewModelFOV = 65
SWEP.HoldType = "revolver"
SWEP.UseHands = true

SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DurationRevealAura = 0.5

SWEP.Damage = 40
SWEP.MaxStep = 5
SWEP.MaxDash = 1
SWEP.Action = 2

function SWEP:Shoot()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    local dir = owner:GetAimVector()
    local start = owner:GetShootPos()
    local range = 10000 --? Should reach the whole map

    local trace = ents.FindAlongRay(start, start + dir * range) 
    for key, ply in ipairs(trace) do
        if (ply:IsPlayer() and table.HasValue(BoringFPS_CONFIG.Vars.PlayersAlive, ply)) then
            local dmginfo = DamageInfo()
            dmginfo:SetDamage(self.Damage)
            dmginfo:SetDamageType(DMG_BULLET)
            dmginfo:SetAttacker(self:GetOwner() or self)
            dmginfo:SetInflictor(self:GetOwner() or self)

            ply:TakeDamage(dmginfo)
        end
    end
end

function SWEP:SecondaryShoot()
    local owner = self:GetOwner()

    if (CLIENT) then 
        BoringFPS.RevealAura(self.DurationRevealAura, BoringFPS_CONFIG.Vars.PlayersAlive, Color(255, 39, 39))
    else
        BoringFPS.PlaySound(BoringFPS_CONFIG.Sounds.RevealAura, false)
        owner:SetNWInt("Action", owner:GetNWInt("Action", 0) - 1)
    end
end

function SWEP:Reload()
end

function SWEP:CanFire()
    return (self:GetOwner():CanUseAction())
end