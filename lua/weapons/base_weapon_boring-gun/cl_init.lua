include('shared.lua')

SWEP.PrintName = "Base Boring gun"
SWEP.Author = "MrMarrant"
SWEP.Purpose = "Parent class for every boring gun"
SWEP.DrawCrosshair = true
SWEP.AutoSwitchTo = true
SWEP.DrawAmmo = true

function SWEP:DrawHUD()
    local owner = self:GetOwner()
    if (owner:GetNWString("State", "free") == "play") then
        local x, y = BoringFPS_CONFIG.Vars.ScrW * 0.8, BoringFPS_CONFIG.Vars.ScrH * 0.85
        local clip1 = self:Clip1()
        local maxClip1 = self:GetMaxClip1()
        local squareW = 20
        local squareH = 20

        if (maxClip1 > 0) then
            BoringFPS.DrawIconHud(BoringFPS_CONFIG.Icons.WeaponIcon, x, y)
            draw.DrawText(clip1, "HudBoringFPS", x + 50, y - 10, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            BoringFPS.DrawSquare(x + 70, y, clip1, maxClip1, squareW, squareH, 5, 50)
        else
            BoringFPS.DrawIconHud(BoringFPS_CONFIG.Icons.InfiniteIcon, x, y)
        end
    end
end