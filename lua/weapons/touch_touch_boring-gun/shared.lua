AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Base = "base_weapon_boring-gun"
SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.Category = "Boring gun"
SWEP.ViewModel = Model( "" )
SWEP.WorldModel = Model( "models/maxofs2d/camera.mdl" )

SWEP.ViewModelFOV = 65
SWEP.HoldType = "camera"
SWEP.UseHands = true

SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.RangeAttack = 100
SWEP.PlayersHit = {}

SWEP.Damage = 30
SWEP.MaxStep = 25
SWEP.MaxDash = 2
SWEP.Action = 99
SWEP.WalkSpeed = 400
SWEP.RunSpeed = 470

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
    self.Action = #BoringFPS_CONFIG.Vars.PlayersAlive - 1
    hook.Add("PlayerTurnStart", "BoringFPS:PlayerTurnStart_Touch_"..self:EntIndex(), function(ply)
        if IsValid(ply) and ply == self:GetOwner() then
            self.Action = #BoringFPS_CONFIG.Vars.PlayersAlive - 1
        end
    end)
    hook.Add("PlayerTurnEnd", "BoringFPS:PlayerTurnEnd_Touch_"..self:EntIndex(), function(ply)
        if IsValid(ply) and ply == self:GetOwner() then
            ply:SetVisibilityRender(true)
        end
    end)
    hook.Add("PlayerDeath", "BoringFPS:CheckTouchDeath_"..self:EntIndex(),function(ply)
        self:OnPlayerLeave(ply)
    end)
    hook.Add("PlayerDisconnect", "BoringFPS:CheckTouchDisconnect_"..self:EntIndex(), function(ply)
        self:OnPlayerLeave(ply)
    end)
end

function SWEP:Shoot()
    if CLIENT then return end

    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    local dir = owner:GetAimVector()

    local traceData = {}
    traceData.start = owner:GetShootPos()
    traceData.endpos = traceData.start + dir * self.RangeAttack
    traceData.filter = owner

    local trace = util.TraceLine(traceData)

    if trace.Hit and IsValid(trace.Entity) and trace.Entity:IsPlayer() and not self.PlayersHit[trace.Entity] then
        self.PlayersHit[trace.Entity] = true
        -- TODO : Faire un affichage dès joueurs déjà touché ?
        if (self:TouchComplete(1)) then
            owner:SetVisibilityRender(false)
        else
            owner:EmitSound("physics/flesh/flesh_impact_hard5.wav")
        end
    else
        owner:EmitSound("npc/zombie/claw_miss1.wav")
    end
end

function SWEP:Reload()
end

function SWEP:CanFire()
    return (self:GetOwner():CanUseAction())
end

function SWEP:TouchComplete(decrement)
    local owner = self:GetOwner()
    if (table.Count(self.PlayersHit) >= #BoringFPS_CONFIG.Vars.PlayersAlive - decrement) then
        for ply, k in pairs(self.PlayersHit) do
            ply:TakeDamage(self.Damage, owner, self)
        end
        self.PlayersHit = {}
        owner:SetNWInt("Action", 0)
        owner:EmitSound("npc/zombie_poison/pz_alert1.wav")
        owner:ChatPrint("Vous avez touchés tout les joueurs.")
        return true
    end
    return false
end

function SWEP:OnRemove()
    hook.Remove("PlayerTurnStart", "BoringFPS:PlayerTurnStart_Touch_"..self:EntIndex())
    hook.Remove("PlayerTurnEnd", "BoringFPS:PlayerTurnEnd_Touch_"..self:EntIndex())
    hook.Remove("PlayerDeath", "BoringFPS:CheckTouchDeath_"..self:EntIndex())
    hook.Remove("PlayerDisconnect", "BoringFPS:CheckTouchDisconnect_"..self:EntIndex())
end

function SWEP:OnPlayerLeave(ply)
    print("OnPlayerLeave touch")
    if IsValid(ply) then
        self.PlayersHit[ply] = nil
        if (table.HasValue(BoringFPS_CONFIG.Vars.PlayersInGame, ply)) then
            self:TouchComplete(2)
        end
    end
end