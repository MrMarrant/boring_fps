AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Base = "base_weapon_boring-gun"
SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.Category = "Boring gun"
SWEP.ViewModel = Model( "models/weapons/c_357.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_357.mdl" )

SWEP.ViewModelFOV = 65
SWEP.HoldType = "revolver"

SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.WeaponName = "stalker"

SWEP.DurationRevealAura = 1

function SWEP:Shoot()
    local owner = self:GetOwner()
    self:ShootBullet(0, 0, 0) --? Animation de tir s'active via cette méthode à prioris
    if not IsValid(owner) or CLIENT then return end

    local dir = owner:GetAimVector()
    local start = owner:GetShootPos()
    local range = 10000 --? Should reach the whole map

    owner:EmitSound("weapons/crossbow/fire1.wav")
    local trace = ents.FindAlongRay(start, start + dir * range) 
    for key, ply in ipairs(trace) do
        if (ply:IsPlayer() and ply ~= owner and table.HasValue(BoringFPS_CONFIG.Vars.PlayersAlive, ply)) then
            local dmginfo = DamageInfo()
            dmginfo:SetDamage(self.Damage)
            dmginfo:SetDamageType(DMG_BULLET)
            dmginfo:SetAttacker(self:GetOwner() or self)
            dmginfo:SetInflictor(self:GetOwner() or self)

            ply:TakeDamageInfo(dmginfo)
        end
    end
end

function SWEP:SecondaryShoot()
    local owner = self:GetOwner()

    if (CLIENT) then
        BoringFPS.RevealAura(self.DurationRevealAura, BoringFPS_CONFIG.Vars.PlayersAlive, Color(255, 0, 0))
    else
        BoringFPS.RevealAura(2, {owner}, Color(255, 0, 0))
        BoringFPS.ReadSound(BoringFPS_CONFIG.Sounds.RevealAura, game.GetWorld(), 0 )
        owner:SetAction(owner:GetNWInt("Action", 0) - 1, true)
    end
end