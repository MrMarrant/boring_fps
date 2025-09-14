local PLAYER = FindMetaTable("Player")

function PLAYER:CanUseAction()
    return (self:GetNWString("State", "free") == "play" and self:GetNWInt("Action", 0) > 0)
end