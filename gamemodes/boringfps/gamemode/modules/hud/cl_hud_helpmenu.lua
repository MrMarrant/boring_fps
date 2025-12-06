local function OpenHelperClassMenu(main, pFrame, scrW, scrH)
    local listWeapon = BoringFPS_CONFIG.Settings.Weapons
    local helper = vgui.Create("DFrame", main)
    helper:SetSize(scrW, scrH)
    helper:Center()
    helper:SetTitle("")
    helper:MakePopup()
    helper:SetDraggable(false)
    helper:ShowCloseButton(false)
    helper.Paint = function(self, w, h)
        BoringFPS.DrawRoundedOutlinedBox(0, scrW * 0.1, scrH * 0.15, scrW * 0.8, scrH * 0.8  , 1 , Color(35, 31, 32, 213), Color(223, 222, 206))
    end

    local btnQuit = vgui.Create("DButton", helper)
    btnQuit:SetSize(scrW * 0.05, scrH * 0.05)
    btnQuit:SetPos(scrW * 0.93, scrH * 0.02)
    btnQuit:SetText("X")
    btnQuit:SetFont("DermaLarge")
    btnQuit.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(35, 31, 32))
        draw.RoundedBox(0, 0, 0, w, h * 0.1, Color(223, 222, 206))
    end

    btnQuit.DoClick = function()
        helper:Remove()
        pFrame:SetVisible(true)
    end

    local margin = 5
    local totalWidth = scrW * 0.8
    local count = table.Count(listWeapon)
    local buttonWidth = (totalWidth - (margin * (count - 1))) / count
    local buttonHeight = 40
    local yPos = scrH * 0.12 - (buttonHeight / 2)
    local i = 1

    for key, weapon in pairs(listWeapon) do
        if (i == 1) then helper.SelectedWeapon = key end
        local btn = vgui.Create("DButton", helper)
        btn:SetText("")
        btn:SetSize(buttonWidth, buttonHeight)
        btn:SetPos(scrW * 0.1 + (i - 1) * (buttonWidth + margin), yPos)

        btn.Paint = function(self, w, h)
            local colorTxtSelect = helper.SelectedWeapon == key and Color(0, 0, 0) or Color(255, 255, 255)
            local colorTxt = self.Hovered and Color(170, 0, 0) or colorTxtSelect
            local colorBG = helper.SelectedWeapon == key and Color(255, 255, 255, 200) or Color(25, 25, 25, 200)
            surface.SetDrawColor(colorBG)
            surface.DrawRect(0, 0, w, h)
            draw.SimpleText(weapon.Name, "DefaultVT", w / 2, h / 2.5, colorTxt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        btn.OnCursorEntered = function(self)
            self.Hovered = true
        end

        btn.OnCursorExited = function(self)
            self.Hovered = false
        end

        btn.DoClick = function()
            helper.SelectedWeapon = key
        end
        i = i + 1
    end

    local description = vgui.Create("DFrame", helper)
    description:SetSize(scrW * 0.79, scrH * 0.3)
    description:SetPos(scrW * 0.105, scrH * 0.18)
    description:SetTitle("")
    description:SetDraggable(false)
    description:ShowCloseButton(false)
    description.Paint = function(self, w, h)
        local currentDescription = BoringFPS.GetTranslation(listWeapon[helper.SelectedWeapon].Description)
        BoringFPS.DrawRoundedOutlinedBox(0, 0, h * 0.1, w, h * 0.9, 1 , Color(35, 31, 32), Color(223, 222, 206))
        draw.RoundedBox(0, 0, 0, w * 0.15, h * 0.1, Color(223, 222, 206))
        draw.SimpleText(BoringFPS.GetTranslation("description_class"), "SmallVT", w * 0.075, h * 0.04, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        local lines = BoringFPS.WrapText(currentDescription, "SmallVT", w * 0.95)
        local y = h * 0.08
        local yLine = h * 0.1
        for i, line in ipairs(lines) do
            local newY = y + (i - 1) * yLine
            draw.DrawText(line, "SmallVT", w * 0.01, newY, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        end
    end

    local stats = vgui.Create("DFrame", helper)
    stats:SetSize(scrW * 0.4, scrH * 0.4)
    stats:SetPos(scrW * 0.105, scrH * 0.6)
    stats:SetTitle("")
    stats:SetDraggable(false)
    stats:ShowCloseButton(false)
    stats.Paint = function(self, w, h)
        local weapon = listWeapon[helper.SelectedWeapon]
        BoringFPS.DrawRoundedOutlinedBox(0, 0, h * 0.1, w, h * 0.1, 1 , Color(35, 31, 32), Color(223, 222, 206))
        BoringFPS.DrawRoundedOutlinedBox(0, 0, h * 0.2, w, h * 0.1, 1 , Color(35, 31, 32), Color(223, 222, 206))
        BoringFPS.DrawRoundedOutlinedBox(0, 0, h * 0.3, w, h * 0.1, 1 , Color(35, 31, 32), Color(223, 222, 206))
        BoringFPS.DrawRoundedOutlinedBox(0, 0, h * 0.4, w, h * 0.1, 1 , Color(35, 31, 32), Color(223, 222, 206))
        BoringFPS.DrawRoundedOutlinedBox(0, 0, h * 0.5, w, h * 0.1, 1 , Color(35, 31, 32), Color(223, 222, 206))
        draw.RoundedBox(0, 0, 0, w * 0.15, h * 0.1, Color(223, 222, 206))
        draw.SimpleText(BoringFPS.GetTranslation("stats_class"), "SmallVT", w * 0.075, h * 0.04, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        BoringFPS.DrawIconHud(BoringFPS_CONFIG.Icons.ActionIcon, w * 0.02, h * 0.13, Color(255, 255, 255), w * 0.04, w * 0.04)
        draw.SimpleText(BoringFPS.GetTranslation("action_class"), "SmallVT", w * 0.1, h * 0.14, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(weapon.Action, "SmallVT", w * 0.7, h * 0.14, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        BoringFPS.DrawIconHud(BoringFPS_CONFIG.Icons.StepIcon, w * 0.02, h * 0.23, Color(255, 255, 255), w * 0.04, w * 0.04)
        draw.SimpleText(BoringFPS.GetTranslation("move_class"), "SmallVT", w * 0.1, h * 0.24, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(weapon.MaxStep, "SmallVT", w * 0.7, h * 0.24, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        BoringFPS.DrawIconHud(BoringFPS_CONFIG.Icons.DashIcon, w * 0.02, h * 0.33, Color(255, 255, 255), w * 0.04, w * 0.04)
        draw.SimpleText(BoringFPS.GetTranslation("dash_class"), "SmallVT", w * 0.1, h * 0.34, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(weapon.MaxDash, "SmallVT", w * 0.7, h * 0.34, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        BoringFPS.DrawIconHud(BoringFPS_CONFIG.Icons.WeaponIcon, w * 0.02, h * 0.43, Color(255, 255, 255), w * 0.04, w * 0.04)
        draw.SimpleText(BoringFPS.GetTranslation("ammos_class"), "SmallVT", w * 0.1, h * 0.44, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(weapon.MaxAmmo == -1 and "∞" or weapon.MaxAmmo, "SmallVT", w * 0.7, h * 0.44, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        BoringFPS.DrawIconHud(BoringFPS_CONFIG.Icons.StepIcon, w * 0.02, h * 0.53, Color(255, 255, 255), w * 0.04, w * 0.04)
        draw.SimpleText(BoringFPS.GetTranslation("walkspeed_class"), "SmallVT", w * 0.1, h * 0.54, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(weapon.WalkSpeed .. " u/s", "SmallVT", w * 0.7, h * 0.54, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local icon = vgui.Create("DFrame", helper)
    icon:SetSize(scrW * 0.15, scrH * 0.25)
    icon:SetPos(scrW * 0.7, scrH * 0.6)
    icon:SetTitle("")
    icon:SetDraggable(false)
    icon:ShowCloseButton(false)
    icon.Paint = function(self, w, h)
        local weapon = listWeapon[helper.SelectedWeapon]
        BoringFPS.DrawRoundedOutlinedBox(0, 0, 0, w, h, 1 , Color(31, 35, 32), Color(143, 143, 136))
        BoringFPS.DrawIconHud(weapon.IconClass, w * 0.1, h * 0.1, Color(255, 255, 255), w * 0.8, w * 0.8)
    end
end

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

local function OpenSelectClassMenu(main, pFrame, scrW, scrH)
    local listWeapon = BoringFPS_CONFIG.Settings.Weapons
    local currentClass = LocalPlayer():GetNWString("ClassWeapon", next(BoringFPS_CONFIG.Settings.Weapons))

    local wGM, hGM = scrW * 0.3, scrH * 0.1
    local xGM, yGM = scrW * 0.5 - wGM / 2, scrH * 0.05
    local startX = scrW * 0.1
    local startY = scrH * 0.3
    local curX = startX
    local curY = startY
    local spacingX = scrW * 0.05
    local spacingY = scrH * 0.25
    local btnWidth = scrW * 0.12
    local btnHeight = scrW * 0.12

    local selector = vgui.Create("DFrame", main)
    selector:SetSize(scrW, scrH)
    selector:Center()
    selector:SetTitle("")
    selector:MakePopup()
    selector:SetDraggable(false)
    selector:ShowCloseButton(false)
    selector.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 100))
        BoringFPS.DrawRoundedOutlinedBox(0, xGM, yGM, wGM, hGM, 3 , Color(35, 31, 32), Color(223, 222, 206))
        draw.SimpleText(BoringFPS.GetTranslation("select_class"), "LargeVT", xGM + wGM * 0.5, yGM + hGM * 0.35, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local btnQuit = vgui.Create("DButton", selector)
    btnQuit:SetSize(scrW * 0.05, scrH * 0.05)
    btnQuit:SetPos(scrW * 0.93, scrH * 0.02)
    btnQuit:SetText("X")
    btnQuit:SetFont("DermaLarge")
    btnQuit.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(35, 31, 32))
        draw.RoundedBox(0, 0, 0, w, h * 0.1, Color(223, 222, 206))
    end
    btnQuit.DoClick = function()
        selector:Remove()
        pFrame:SetVisible(true)
    end

    for class, weapon in pairs(listWeapon) do
        if curX + btnWidth > selector:GetWide() - 20 then
            curX = startX
            curY = curY + spacingY
        end

        local btn = vgui.Create("DButton", selector)
        btn:SetSize(btnWidth, btnHeight)
        btn:SetPos(curX, curY)
        btn:SetText("")

        btn.Paint = function(self, w, h)
            BoringFPS.DrawRoundedOutlinedBox(0, 0, 0, w, h, 4 , Color(35, 31, 32), Color(223, 222, 206))
            BoringFPS.DrawIconHud(weapon.IconClass, w * 0.1, h * 0.1, Color(255, 255, 255), w * 0.8, w * 0.8)
            local colorTxt = currentClass == class and Color(206, 252, 0) or Color(255, 255, 255)
            colorTxt = self.Hovered and Color(170, 0, 0) or colorTxt
            draw.SimpleText(class, "DefaultVT", w / 2, h * 0.9, colorTxt, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        btn.DoClick = function()
            RunConsoleCommand("changeclass", class)
            currentClass = class
        end

        curX = curX + btnWidth + spacingX
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
        lply.HelpMenu = nil
    end

    local function CreateStyledButton(parent, text, x, y, icon, sizeX, sizeY)
        local font = "LargeVT"
        local btn = vgui.Create("DButton", parent)
        sizeX = sizeX or scrW * 0.15
        sizeY = sizeY or scrW * 0.15
        btn:SetSize(sizeX, sizeY)
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
            BoringFPS.DrawRoundedOutlinedBox(0, 0, 0, w, h, 4 , Color(35, 31, 32), self.Hovered and Color(163, 163, 163) or Color(223, 222, 206))
            BoringFPS.DrawIconHud(icon, w * 0.1, h * 0.1, Color(255, 255, 255, 3), w * 0.8, w * 0.8)
            local lines = BoringFPS.WrapText(text, font, w - 8)
            local yLine = h * 0.38 - (#lines * 40) / 2
            for i, line in ipairs(lines) do
                draw.DrawText(line, font, w * 0.5, yLine + (i - 1) * 50, self.Hovered and Color(170, 0, 0) or Color(255, 255, 255), TEXT_ALIGN_CENTER)
            end
        end

        return btn
    end

    local rulesButton = CreateStyledButton(frame, BoringFPS.GetTranslation("rule"), scrW * 0.23, scrH * 0.4, BoringFPS_CONFIG.Icons.RulesIcon)
    local classHelperButton = CreateStyledButton(frame, BoringFPS.GetTranslation("class_helper"), scrW * 0.43, scrH * 0.4, BoringFPS_CONFIG.Icons.Info)
    local selectClassButton = CreateStyledButton(frame, BoringFPS.GetTranslation("help_select_class"), scrW * 0.63, scrH * 0.4, BoringFPS_CONFIG.Icons.WeaponIcon)
    local wikiButton = CreateStyledButton(frame, "", scrW * 0.945, scrH * 0.9, BoringFPS_CONFIG.Icons.WikiIcon, scrW * 0.05, scrW * 0.05)

    rulesButton.DoClick = function()
        frame:SetVisible(false)
        OpenRulesMenu(main, frame, scrW, scrH)
    end

    classHelperButton.DoClick = function()
        frame:SetVisible(false)
        OpenHelperClassMenu(main, frame, scrW, scrH)
    end

    selectClassButton.DoClick = function()
        frame:SetVisible(false)
        OpenSelectClassMenu(main, frame, scrW, scrH)
    end
    
    wikiButton.DoClick = function()
        gui.OpenURL(BoringFPS_CONFIG.Settings.WikiURL)
    end
end

net.Receive(BoringFPS_CONFIG.NetVar.OpenHelpMenu, function()
    local scrW, scrH = BoringFPS_CONFIG.Vars.ScrW, BoringFPS_CONFIG.Vars.ScrH
    OpenBoringFPSMenu(scrW, scrH)
end)