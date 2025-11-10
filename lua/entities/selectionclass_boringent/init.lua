if (engine.ActiveGamemode() ~= "boringfps") then return end

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/selector_class/selector_class.mdl")
	self:RebuildPhysics()
end

-- Initialise the physic of the entity
function ENT:RebuildPhysics()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
end

function ENT:Use(activator, caller)
	if not IsValid(activator) or not activator:IsPlayer() then return end
	local CT = CurTime()
	if (self.NextUse > CT) then return end

	activator:ConCommand( "changeclass " .. self:GetNWString( "classgun", "pistol" ) )
    activator:PrintMessage(HUD_PRINTCENTER, "You have changed your class to: " .. self:GetNWString( "classgun", "pistol" ))
	self:EmitSound(BoringFPS_CONFIG.Sounds.OnUse)
	self.NextUse = CT + self.DelayUse
end

function ENT:KeyValue(key, value)
	self:SetNWString( key, value )
end