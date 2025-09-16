local PLAYER = FindMetaTable("Player")

function PLAYER:CanUseAction()
    return (self:GetNWString("State", "free") == "play" and self:GetNWInt("Action", 0) > 0)
end

function PLAYER:SetVisibilityRender(isVisible)
    local renderMode = isVisible and RENDERMODE_TRANSCOLOR or RENDERMODE_TRANSALPHA
    local renderColor = isVisible and Color(255, 255, 255, 255) or Color(0, 0, 0, 0)

    self:SetRenderMode(renderMode)
    self:SetColor(renderColor)
end