local PLAYER = FindMetaTable("Player")

function PLAYER:CanUseAction()
    return (self:GetNWInt("Action", 0) > 0 and self:GetNWString("State", "free") == "play")
end