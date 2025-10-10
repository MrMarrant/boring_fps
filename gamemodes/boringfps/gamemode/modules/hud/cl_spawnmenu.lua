hook.Add("SpawnMenuOpen", "BoringFPS:SpawnMenuOpen", function()
    if (LocalPlayer():HasAccess()) then return true end

    if IsValid(SpawnMenu) then
        SpawnMenu:SetVisible(true)
        SpawnMenu:MakePopup()
        SpawnMenu:Center()
        return true
    end

    local captionImg = {
    ["boringfps/icons/action_icon.png"] = BoringFPS.GetTranslation("action_point"),
    ["boringfps/icons/step_icon.png"] = BoringFPS.GetTranslation("move_point"),
    ["boringfps/icons/dash_icon.png"] = BoringFPS.GetTranslation("dash_point"),
    ["boringfps/icons/weapon_icon.png"] = BoringFPS.GetTranslation("ammo_left"),
    ["boringfps/icons/timer_icon.png"] = BoringFPS.GetTranslation("turn_time")
}

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

    local ruleComp = vgui.Create("DPanel", frame)
    ruleComp:SetSize(frame:GetWide(), frame:GetTall() * 0.3)
    ruleComp:SetPos(0, 0)
    ruleComp.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(35, 31, 32, 225))
    end

    local ruleTitle = vgui.Create("DLabel", ruleComp)
    ruleTitle:SetText(BoringFPS.GetTranslation("rule"))
    ruleTitle:SetFont("DermaLarge")
    ruleTitle:SetTextColor(Color(255, 255, 255))
    ruleTitle:SizeToContents()
    ruleTitle:SetContentAlignment(8)
    ruleTitle:Dock(TOP)
    ruleTitle:DockMargin(0, 10, 0, 0)

    local ruleText = vgui.Create("DLabel", ruleComp)
    ruleText:SetText(BoringFPS.GetTranslation("rule_desc"))
    ruleText:SetFont("TabHUDSmall")
    ruleText:SetTextColor(Color(255, 255, 255))
    ruleText:Center()
    ruleText:DockMargin(10, 0, 30, 0)
    ruleText:DockPadding(40, 0, 20, 0)
    ruleText:SetWrap(true)
    ruleText:Dock(FILL)

    local bottomHeight = frame:GetTall() * 0.7
    local panelWidth = frame:GetWide() / 3

    -- turnComp
    local turnComp = vgui.Create("DPanel", frame)
    turnComp:SetSize(panelWidth, bottomHeight)
    turnComp:SetPos(0, frame:GetTall() * 0.3)
    turnComp.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(48, 57, 47, 225))
        draw.SimpleText(
            BoringFPS.GetTranslation("turn_comp"),
            "DermaLarge",
            w / 2, h * 0.02,
            Color(255, 255, 255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_TOP
        )
        local text = BoringFPS.GetTranslation("turn_indication")
        draw.DrawText(
            text,
            "TabHUDLarge",
            w * 0.01, h * 0.15,
            Color(255, 255, 255),
            TEXT_ALIGN_LEFT
        )
    end

    -- outTurnComp
    local outTurnComp = vgui.Create("DPanel", frame)
    outTurnComp:SetSize(panelWidth, bottomHeight)
    outTurnComp:SetPos(panelWidth, frame:GetTall() * 0.3)
    outTurnComp.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(43, 35, 34, 225))
        draw.SimpleText(
            BoringFPS.GetTranslation("out_turn_comp"),
            "DermaLarge",
            w / 2, h * 0.02,
            Color(255, 255, 255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_TOP
        )
        local text = BoringFPS.GetTranslation("out_of_turn_indication")
        draw.DrawText(
            text,
            "TabHUDLarge",
            w * 0.01, h * 0.15,
            Color(255, 255, 255),
            TEXT_ALIGN_LEFT
        )
    end

    -- iconComp
    local iconComp = vgui.Create("DPanel", frame)
    iconComp:SetSize(panelWidth, bottomHeight)
    iconComp:SetPos(panelWidth * 2, frame:GetTall() * 0.3)
    iconComp.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(83, 110, 213, 225))
        draw.SimpleText(
            BoringFPS.GetTranslation("legend"),
            "DermaLarge",
            w / 2, h * 0.02,
            Color(255, 255, 255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_TOP
        )
    end

    local itemHeight = 40
    local spacingY = 40
    local itemCount = #captionImg
    local imgSize = 40
    local fontLeg = "DermaDefaultBold"
    local totalHeight = (itemHeight * itemCount) + (spacingY * (itemCount - 1))

    local iconList = vgui.Create("DIconLayout", iconComp)
    iconList:SetSize(iconComp:GetWide(), totalHeight)
    iconList:SetPos(0, (iconComp:GetTall() - totalHeight) * 0.15)
    iconList:SetSpaceY(spacingY)
    iconList:SetSpaceX(0)

    for imgPath, text in pairs(captionImg) do
        local item = iconList:Add("DPanel")
        item:SetSize(iconList:GetWide(), itemHeight)
        item.Paint = function(self, w, h)
            surface.SetDrawColor(0, 0, 0, 0)
            surface.DrawRect(0, 0, w, h)
        end

        surface.SetFont(fontLeg)
        local textW = surface.GetTextSize(text)
        local totalW = imgSize + 10 + textW

        local img = vgui.Create("DImage", item)
        img:SetSize(imgSize, imgSize)
        img:SetImage(imgPath)
        img:SetPos((item:GetWide() - totalW) / 2, (itemHeight - imgSize) / 2)

        local lbl = vgui.Create("DLabel", item)
        lbl:SetText(text)
        lbl:SetFont(fontLeg)
        lbl:SetTextColor(Color(255, 255, 255))
        lbl:SizeToContents()
        lbl:SetPos(img:GetX() + imgSize + 10, (itemHeight - lbl:GetTall()) / 2)
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