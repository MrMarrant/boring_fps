include('shared.lua')

SWEP.PrintName = "Touch Touch"
SWEP.Author = "MrMarrant"
SWEP.Purpose = "It shoot & kill"
SWEP.DrawCrosshair = true
SWEP.AutoSwitchTo = true
SWEP.DrawAmmo = true

function SWEP:DrawHUD()
    self:BaseHUD()
    local plyList = BoringFPS_CONFIG.Vars.PlayersInGame
    local scrW, scrH = BoringFPS_CONFIG.Vars.ScrW, BoringFPS_CONFIG.Vars.ScrH
    local x, y = scrW * 0.81, scrH * 0.13
    local posY = y
    local spacing = scrH * 0.068
    local baseHeight = scrH * 0.01
    local baseWidth  = scrW * 0.006

    for index, ply in ipairs(plyList) do
        if (self.PlayersHit[ply]) then
            draw.RoundedBox(100, x, posY, baseWidth, baseHeight, Color(0, 255, 85))
        end
        posY = posY + spacing
    end
end