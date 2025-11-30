include('shared.lua')

SWEP.PrintName = "Base Boring gun"
SWEP.Author = "MrMarrant"
SWEP.Purpose = "Parent class for every boring gun"
SWEP.DrawCrosshair = true
SWEP.AutoSwitchTo = true
SWEP.DrawAmmo = true

function SWEP:DrawHUD()
    self:BaseHUD()
end

function SWEP:BaseHUD()
    local owner = self:GetOwner()
    local scrW, scrH = BoringFPS_CONFIG.Vars.ScrW, BoringFPS_CONFIG.Vars.ScrH
    if (owner:GetNWString("State", "free") == "play") then
        local x, y = scrW * 0.8, scrH * 0.85
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
        BoringFPS.DrawStepLeftHUD(scrW * 0.8, scrH * 0.9, owner:GetNWInt("StepLeft", 0), self.MaxStep)
        BoringFPS.DrawActionLeft(scrW * 0.8, scrH * 0.95, owner:GetNWInt("Action", 0), self.Action)
    elseif(owner:GetNWString("State", "free") == "wait") then
        BoringFPS.DrawDashHud(BoringFPS_CONFIG.Vars.ScrW * 0.8, BoringFPS_CONFIG.Vars.ScrH * 0.9, owner:GetNWInt("Dash", 0), self.MaxDash)
    end
end