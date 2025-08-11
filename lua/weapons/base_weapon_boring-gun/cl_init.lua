include('shared.lua')

SWEP.PrintName = "Base Boring gun"
SWEP.Author = "MrMarrant"
SWEP.Purpose = "Parent class for every boring gun"
SWEP.DrawCrosshair = true
SWEP.AutoSwitchTo = true
SWEP.DrawAmmo = true

--? BoringFPS_CONFIG renvoie nil ici, va savoir pk
local x, y = ScrW()* 0.2, ScrH() * 0.95
local w, h = 200, 30

function SWEP:DrawHUD()
    -- Draw ammo
    local clip1 = self:Clip1()
    local maxClip1 = self:GetMaxClip1()

    draw.RoundedBox(1, x - w/2, y - h/2, w, h, Color(0, 0, 0, 150))
    draw.SimpleText("Ammo: " .. clip1 .. " / " .. maxClip1, "Trebuchet24", x, y, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end