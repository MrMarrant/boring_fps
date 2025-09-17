hook.Add("SpawnMenuOpen", "BoringFPS:SpawnMenuOpen", function()
    if (LocalPlayer():HasAccess()) then return true end

    if IsValid(SpawnMenu) then
        SpawnMenu:SetVisible(true)
        SpawnMenu:MakePopup()
        SpawnMenu:Center()
    else
        local frame = vgui.Create("DFrame")
        frame:SetTitle("")
        frame:ShowCloseButton(false)
        frame:SetDraggable(false)
        frame:SetSizable(false)
        frame:SetDeleteOnClose(false)
        frame:SetSize(BoringFPS_CONFIG.Vars.ScrW * 0.8, BoringFPS_CONFIG.Vars.ScrH * 0.7)
        frame:Center()
        frame:MakePopup()
        frame.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 0))
        end

        SpawnMenu = frame
    end

    return false
end)

hook.Add("OnSpawnMenuClose", "BoringFPS:OnSpawnMenuClose", function()
    if IsValid(SpawnMenu) then
        if (LocalPlayer():HasAccess()) then
            SpawnMenu:SetVisible(false)
        else
            SpawnMenu:Remove()
            SpawnMenu = nil
        end
    end
end)
