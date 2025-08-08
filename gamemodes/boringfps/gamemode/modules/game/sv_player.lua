local meta = FindMetaTable("Player")

function meta:SetState(type)
    if (not BoringFPS_CONFIG.Vars.TypePlay[type]) then
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
end

--! Le joueur peut : avancer / Tirer / Interagir
function meta:Play()
    self:SetWalkSpeed( 200 )
    self:SetRunSpeed( 200 )
    self:SetJumpPower( 200 )
    self:ChatPrint("Vous êtes en train de jouer.")
end