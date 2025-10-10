local function OpenRulesMenu(main, pFrame, scrW, scrH)
        local captionImg = {
            ["boringfps/icons/action_icon.png"] = BoringFPS.GetTranslation("action_point"),
            ["boringfps/icons/step_icon.png"] = BoringFPS.GetTranslation("move_point"),
            ["boringfps/icons/dash_icon.png"] = BoringFPS.GetTranslation("dash_point"),
            ["boringfps/icons/weapon_icon.png"] = BoringFPS.GetTranslation("ammo_left"),
            ["boringfps/icons/timer_icon.png"] = BoringFPS.GetTranslation("turn_time")
        }

    local rule = vgui.Create("DFrame", main)
    rule:SetTitle("")
    rule:ShowCloseButton(false)
    rule:SetDraggable(false)
    rule:SetSizable(false)
    rule:SetDeleteOnClose(false)
    rule:SetSize(scrW * 0.8, scrH * 0.7)
    rule:Center()
    rule:MakePopup()
    rule.Paint = function(self, w, h)
        BoringFPS.DrawRoundedOutlinedBox(0, 0, 0, w, h, 1, Color(35, 31, 32), Color(223, 222, 206))
        draw.RoundedBox(0, 0, 0, w, h * 0.015, Color(223, 222, 206))
    end
    
    local wFrame, hFrame = rule:GetWide(), rule:GetTall()
    local ruleComp = vgui.Create("DPanel", rule)
    ruleComp:SetSize(wFrame, hFrame * 0.3)
    ruleComp:SetPos(0, 0)
    ruleComp.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 0))
    end

    local ruleTitle = vgui.Create("DLabel", ruleComp)
    ruleTitle:SetText(BoringFPS.GetTranslation("rule"))
    ruleTitle:SetFont("DermaLarge")
    ruleTitle:SetTextColor(Color(255, 255, 255))
    ruleTitle:SizeToContents()
    ruleTitle:SetContentAlignment(8)
    ruleTitle:Dock(TOP)
    ruleTitle:DockMargin(0, 20, 0, 0)

    local ruleText = vgui.Create("DLabel", ruleComp)
    ruleText:SetText(BoringFPS.GetTranslation("rule_desc"))
    ruleText:SetFont("TabHUDSmall")
    ruleText:SetTextColor(Color(255, 255, 255))
    ruleText:Center()
    ruleText:DockMargin(10, 0, 30, 0)
    ruleText:DockPadding(40, 0, 20, 0)
    ruleText:SetWrap(true)
    ruleText:Dock(FILL)

    local bottomHeight = hFrame * 0.7
    local panelWidth = wFrame / 3

    -- turnComp
    local turnComp = vgui.Create("DPanel", rule)
    turnComp:SetSize(panelWidth, bottomHeight)
    turnComp:SetPos(0, hFrame * 0.3)
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
    local outTurnComp = vgui.Create("DPanel", rule)
    outTurnComp:SetSize(panelWidth, bottomHeight)
    outTurnComp:SetPos(panelWidth, hFrame * 0.3)
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
    local iconComp = vgui.Create("DPanel", rule)
    iconComp:SetSize(panelWidth, bottomHeight)
    iconComp:SetPos(panelWidth * 2, hFrame * 0.3)
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

    local btnQuit = vgui.Create("DButton", rule)
    btnQuit:SetSize(wFrame * 0.05, hFrame * 0.05)
    btnQuit:SetPos(wFrame * 0.95, hFrame * 0.02)
    btnQuit:SetText("X")
    btnQuit:SetFont("DermaLarge")
    btnQuit.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(35, 31, 32))
    end

    btnQuit.DoClick = function()
        rule:Remove()
        pFrame:SetVisible(true)
    end
end

local function OpenBoringFPSMenu(scrW, scrH)
    local lply = LocalPlayer()
    local wGM, hGM = scrW * 0.3, scrH * 0.15
    local xGM, yGM = scrW * 0.5 - wGM / 2, scrH * 0.05
    local main = vgui.Create("DFrame")
    main:SetTitle("")
    main:ShowCloseButton(false)
    main:SetDraggable(false)
    main:SetSizable(false)
    main:SetDeleteOnClose(false)
    main:SetSize(scrW, scrH)
    main:Center()
    main:MakePopup()
    main.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h , Color(255, 255, 255, 0))
    end
    local frame = vgui.Create("DFrame", main)
    frame:SetSize(scrW, scrH)
    frame:Center()
    frame:SetTitle("")
    frame:MakePopup()
    frame:ShowCloseButton(false)
    frame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 100))
        BoringFPS.DrawRoundedOutlinedBox(0, xGM, yGM, wGM, hGM, 1 , Color(35, 31, 32), Color(223, 222, 206))
        draw.RoundedBox(0, xGM, yGM, wGM, hGM * 0.1, Color(223, 222, 206))
        draw.SimpleText("BORING FPS", "LargeVT", xGM + wGM * 0.5, yGM + hGM * 0.35, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("By MrMarrant", "DefaultVT", xGM + wGM * 0.5, yGM + hGM * 0.35 + 50, Color(255, 220, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    lply.HelpMenu = main

    local btnQuit = vgui.Create("DButton", frame)
    btnQuit:SetSize(scrW * 0.05, scrH * 0.05)
    btnQuit:SetPos(scrW * 0.93, scrH * 0.02)
    btnQuit:SetText("X")
    btnQuit:SetFont("DermaLarge")
    btnQuit.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(35, 31, 32))
        draw.RoundedBox(0, 0, 0, w, h * 0.1, Color(223, 222, 206))
    end

    btnQuit.DoClick = function()
        lply.HelpMenu:Remove()
    end

    local function CreateStyledButton(parent, text, x, y, icon)
        local font = "LargeVT"
        local btn = vgui.Create("DButton", parent)
        btn:SetSize(scrW * 0.15, scrW * 0.15)
        btn:SetPos(x, y)
        btn:SetText("")
        btn.Hovered = false

        btn.OnCursorEntered = function(self)
            self.Hovered = true
        end
        btn.OnCursorExited = function(self)
            self.Hovered = false
        end

        btn.Paint = function(self, w, h)
            BoringFPS.DrawRoundedOutlinedBox(0, 0, 0, w, h, 4 , Color(35, 31, 32), Color(223, 222, 206))
            BoringFPS.DrawIconHud(icon, w * 0.1, h * 0.1, Color(255, 255, 255, 3), w * 0.8, w * 0.8)
            local lines = BoringFPS.WrapText(text, font, w - 8)
            local yLine = h * 0.38 - (#lines * 40) / 2
            for i, line in ipairs(lines) do
                draw.DrawText(line, font, w * 0.5, yLine + (i - 1) * 50, self.Hovered and Color(170, 0, 0) or Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        return btn
    end

    local rulesButton = CreateStyledButton(frame, "Rules", scrW * 0.3, scrH * 0.4, BoringFPS_CONFIG.Icons.RulesIcon)
    local classHelperButton = CreateStyledButton(frame, "Class Helper", scrW * 0.55, scrH * 0.4, BoringFPS_CONFIG.Icons.Info)

    rulesButton.DoClick = function()
        frame:SetVisible(false)
        OpenRulesMenu(main, frame, scrW, scrH)
    end

    classHelperButton.DoClick = function()
        chat.AddText(Color(255, 200, 0), "[BORING FPS] ", Color(255, 255, 255), "Class Helper button clicked!")
    end
end

net.Receive(BoringFPS_CONFIG.NetVar.OpenHelpMenu, function()
    local scrW, scrH = BoringFPS_CONFIG.Vars.ScrW, BoringFPS_CONFIG.Vars.ScrH
    OpenBoringFPSMenu(scrW, scrH)
end)