AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Base = "base_weapon_boring-gun"
SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.Category = "Boring gun"
SWEP.ViewModel = ""
SWEP.WorldModel = Model( "models/maxofs2d/camera.mdl" )

SWEP.ViewModelFOV = 65
SWEP.HoldType = "camera"

SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.WeaponName = "touch"

SWEP.RangeAttack = 100
SWEP.PlayersHit = {}

function SWEP:InitializeWeapon()
    hook.Add("PlayerTurnEnd", "BoringFPS:PlayerTurnEnd_Touch_"..self:EntIndex(), function(ply)
        if IsValid(ply) and ply == self:GetOwner() then
            BoringFPS.SetVisibilityRender(ply, true)
            BoringFPS.SetVisibilityRender(self, true)
        end
    end)
end

function SWEP:Shoot()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    local dir = owner:GetAimVector()

    local traceData = {}
    traceData.start = owner:GetShootPos()
    traceData.endpos = traceData.start + dir * self.RangeAttack
    traceData.filter = owner

    local trace = util.TraceLine(traceData)
    local sfx

    if trace.Hit and IsValid(trace.Entity) and trace.Entity:IsPlayer() and not self.PlayersHit[trace.Entity] then
        self.PlayersHit[trace.Entity] = true
        sfx = "physics/flesh/flesh_squishy_impact_hard1.wav"
    else
        sfx = "npc/zombie/claw_miss1.wav"
    end
    if (SERVER) then owner:EmitSound(sfx) end
end

function SWEP:SecondaryShoot()

    local owner = self:GetOwner()
    owner:EmitSound(BoringFPS_CONFIG.Sounds.Detonate)
    if not IsValid(owner) or table.IsEmpty(self.PlayersHit) then return end

    if (SERVER) then
        if (#self.PlayersHit >= #BoringFPS_CONFIG.Vars.PlayersAlive) then
            BoringFPS.SetVisibilityRender(owner, false)
            BoringFPS.SetVisibilityRender(self, false)
        end
    else
        owner:ChatPrint(BoringFPS.GetTranslation("touch_explode"))
    end
    self:Detonate(owner)
    BoringFPS.ReadSound("weapons/physcannon/energy_sing_explosion2.wav", game.GetWorld(), 0)
    owner:SetAction(0, true)
end

function SWEP:Reload()
end

function SWEP:CanFire()
    return (self:GetOwner():CanUseAction())
end

function SWEP:OnRemove()
    hook.Remove("PlayerTurnEnd", "BoringFPS:PlayerTurnEnd_Touch_"..self:EntIndex())
end

function SWEP:Detonate(owner)
    if SERVER then
        for ply, k in pairs(self.PlayersHit) do
            ply:TakeDamage(self.Damage, owner, self)
        end
    end
    self.PlayersHit = {}
end