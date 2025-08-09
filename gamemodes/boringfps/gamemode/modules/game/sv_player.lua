local meta = FindMetaTable("Player")

--! Si ça fonctionne bien, faire de même avec le 'state'
function meta:SetupDataTables()
    self:NetworkVar("Int", 0, "StepLeft")
end

local TypePlay = {
    ["play"] = true,
    ["wait"] = true
}

function meta:UpdateStepLeft(step)
    meta:SetStepLeft(step)
    if (step <= 0) then
        self:SetWalkSpeed( 1 )
        self:SetRunSpeed( 1 )
        self:SetJumpPower( 0 )
        hook.Remove("PlayerFootstep:CountStep:Player-" .. self:EntIndex())
        self:ChatPrint("Vous avez utilisez tout vos déplacements.")
    end
end

function meta:SetState(type)
    if (not TypePlay[type]) then
        ErrorNoHaltWithStack("Invalid type for SetState: " .. tostring(type) .. "\n")
        return
    end
    BoringFPS_CONFIG.Vars.PlayersVars[self] = BoringFPS_CONFIG.Vars.PlayersVars[self] or {}
    BoringFPS_CONFIG.Vars.PlayersVars[self]["State"] = type

    if (type == "play") then
        self:Play()
    else
        self:Wait()
    end
end

function meta:GetState()
    local vars = BoringFPS_CONFIG.Vars.PlayersVars[self]
    if vars == nil then return 0 end

    local result = vars["State"]
    if result == nil then return 0 end

    return result
end

--! Le joueur peut : tourner la caméra / dash
function meta:Wait()
    self:SetWalkSpeed( 1 )
    self:SetRunSpeed( 1 )
    self:SetJumpPower( 0 )
    self:ChatPrint("Vous êtes en attente.")
    hook.Remove("PlayerFootstep:CountStep:Player-" .. self:EntIndex())
end

--! Le joueur peut : avancer / Tirer / Interagir
function meta:Play()
    self:SetWalkSpeed( 200 )
    self:SetRunSpeed( 200 )
    self:SetJumpPower( 200 )
    self:ChatPrint("Vous êtes en train de jouer.")
    -- TODO : Tester pour calculer le nombres de pas limites
    meta:SetStepLeft(BoringFPS_CONFIG.Settings.DefaultMaxStep)
    hook.Add( "PlayerFootstep", "PlayerFootstep:CountStep:Player-" .. self:EntIndex(), function( ply )
        if (ply == self) ply:UpdateStepLeft(ply:GetStepLeft() - 1)
        return false
    end )
end