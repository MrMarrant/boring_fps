local PLAYER = FindMetaTable("Player")

function PLAYER:CanUseAction()
    return (self:GetNWString("State", "free") == "play" and self:GetNWInt("Action", 0) > 0)
end

function PLAYER:HasAccess()
    return (self:IsAdmin() or self:IsSuperAdmin())
end

function PLAYER:SetAction(action, use)
    self:SetNWInt("Action", action)
    if (use) then
        hook.Call("OnNewDataPlayer", nil, self, "action_done")
    end
end

hook.Add( "PlayerFootstep", "BoringFPS:PlayerFootstep:CountStep", function( ply )
    if (GetGlobalBool("GameInProgress") and BoringFPS_CONFIG.Vars.PlayersInGame[ply:GetNWInt("NumberTurn")]) then
        local stepLeft = ply:GetNWInt("StepLeft", 0)
        if (ply:GetNWString("State", "free") == "play" and stepLeft > 0 and SERVER) then
            ply:UpdateStepLeft(stepLeft - 1)
        elseif (ply:GetNWString("State", "free") == "wait" or stepLeft <= 0) then
            return true
        end
    end
    return false
end )