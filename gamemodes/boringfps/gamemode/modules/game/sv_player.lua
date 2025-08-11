local PLAYER = FindMetaTable("Player")

local TypePlay = {
    ["play"] = function (ply) ply:Play() end,
    ["wait"] = function (ply) ply:Wait() end,
    ["free"] = function (ply) ply:Free() end
}

function PLAYER:UpdateStepLeft(step)
    self:SetNWInt("StepLeft",step)
    if (step <= 0) then
        self:SetWalkSpeed( 1 )
        self:SetRunSpeed( 1 )
        self:SetJumpPower( 0 )
        hook.Remove("PlayerFootstep", "PlayerFootstep:CountStep:Player-" .. self:EntIndex())
        self:ChatPrint("Vous avez utilisez tout vos déplacements.")
    end
end

function PLAYER:SetState(typeState)
    if (not TypePlay[typeState]) then
        ErrorNoHaltWithStack("Invalid type for SetState: " .. tostring(typeState) .. "\n")
        return
    end
    BoringFPS_CONFIG.Vars.PlayersVars[self] = BoringFPS_CONFIG.Vars.PlayersVars[self] or {}
    BoringFPS_CONFIG.Vars.PlayersVars[self]["State"] = typeState

    TypePlay[typeState](self)
end

function PLAYER:GetState()
    local vars = BoringFPS_CONFIG.Vars.PlayersVars[self]
    if vars == nil then return 0 end

    local result = vars["State"]
    if result == nil then return 0 end

    return result
end

--! Le joueur peut : tourner la caméra / dash
function PLAYER:Wait()
    self:SetWalkSpeed( 1 )
    self:SetRunSpeed( 1 )
    self:SetJumpPower( 0 )
    self:ChatPrint("Vous êtes en attente.")
    hook.Remove("PlayerFootstep", "PlayerFootstep:CountStep:Player-" .. self:EntIndex())
end

--! Le joueur peut : avancer / Tirer / Interagir
function PLAYER:Play()
    self:SetWalkSpeed( 150 )
    self:SetRunSpeed( 200 )
    self:SetJumpPower( 200 )
    self:ChatPrint("Vous êtes en train de jouer.")
    -- TODO : Tester pour calculer le nombres de pas limites
    self:SetNWInt("StepLeft", BoringFPS_CONFIG.Settings.DefaultMaxStep)
    hook.Add( "PlayerFootstep", "PlayerFootstep:CountStep:Player-" .. self:EntIndex(), function( ply )
        if (ply == self) then ply:UpdateStepLeft(ply:GetNWInt("StepLeft") - 1) end
        return false
    end )
end

function PLAYER:Free()
    self:SetWalkSpeed( 150 )
    self:SetRunSpeed( 200 )
    self:SetJumpPower( 200 )
    hook.Remove("PlayerFootstep", "PlayerFootstep:CountStep:Player-" .. self:EntIndex())
end

hook.Add("PlayerInitialSpawn", "PlayerInitialSpawn:BoringFPS:SetupData", function(ply)
    ply:SetNWInt("NumberTurn", -1)
    ply:SetNWInt("StepLeft", -1)
end)