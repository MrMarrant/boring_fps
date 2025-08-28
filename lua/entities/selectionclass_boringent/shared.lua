ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Author = "MrMarrant"
ENT.PrintName = "Selector Class"
ENT.Spawnable = false
ENT.Category = "Boring Entity"

ENT.DelayUse = 1
ENT.NextUse = CurTime()

ENT.IconsClass = {
    ["pistol"] = BoringFPS_CONFIG.Icons.WeaponIcon,
    ["shootgun"] = BoringFPS_CONFIG.Icons.ActionIcon,
    ["launcher"] = BoringFPS_CONFIG.Icons.StepIcon,
    ["crowbar"] = BoringFPS_CONFIG.Icons.DashIcon
}