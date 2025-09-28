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