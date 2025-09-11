local captionImg = {
    ["boringfps/icons/action_icon.png"] = "Points d’action",
    ["boringfps/icons/step_icon.png"] = "Points de mouvements",
    ["boringfps/icons/dash_icon.png"] = "Points de dash",
    ["boringfps/icons/weapon_icon.png"] = "Munition restante",
    ["boringfps/icons/timer_icon.png"] = "Temps restant du tour"
}

hook.Add("ScoreboardShow", "BoringFPS:CustomScoreboard", function()
    if IsValid(g_Scoreboard) then
        g_Scoreboard:SetVisible(true)
        g_Scoreboard:MakePopup()
        g_Scoreboard:Center()
        return true
    end

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

    g_Scoreboard = frame

    local ruleComp = vgui.Create("DPanel", frame)
    ruleComp:SetSize(frame:GetWide(), frame:GetTall() * 0.3)
    ruleComp:SetPos(0, 0)
    ruleComp.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(35, 31, 32, 225))
    end

    local ruleTitle = vgui.Create("DLabel", ruleComp)
    ruleTitle:SetText("Règle du jeu")
    ruleTitle:SetFont("DermaLarge")
    ruleTitle:SetTextColor(Color(255, 255, 255))
    ruleTitle:SizeToContents()
    ruleTitle:SetContentAlignment(8)
    ruleTitle:Dock(TOP)
    ruleTitle:DockMargin(0, 10, 0, 0)

    local ruleText = vgui.Create("DLabel", ruleComp)
    ruleText:SetText("Le but du jeu est d’être le dernier survivant de la partie en cours.\nVous jouez chacun votre tour, pendant une durée définie.\nVous pouvez réaliser des actions durant votre tour, ainsi que lorsque ce n’est pas votre tour.\nVous avez le choix entre plusieurs classes, chacune vous donnera accès à une arme unique ainsi que des caractéristiques uniques dans le salon du lobby de pregame.")
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
            "Tour actuel",
            "DermaLarge",
            w / 2, h * 0.02,
            Color(255, 255, 255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_TOP
        )
        local text = "- Utiliser une action\n  → Tirer\n  → Action spéciale de l’arme\n  → Recharger\n\n- Utiliser les points de déplacements"
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
            "En dehors de votre tour",
            "DermaLarge",
            w / 2, h * 0.02,
            Color(255, 255, 255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_TOP
        )
        local text = "- Utiliser vos points de dash pour éviter\nles tirs des autres joueurs"
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
            "Légende",
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

    return true
end)

hook.Add("ScoreboardHide", "BoringFPS:CustomScoreboardHide", function()
    if IsValid(g_Scoreboard) then
        g_Scoreboard:SetVisible(false)
    end
end)
