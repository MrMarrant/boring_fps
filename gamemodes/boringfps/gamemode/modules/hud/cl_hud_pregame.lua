local differenceExp = BoringFPS_CONFIG.Settings.DifferenceExperienceBetweenLevels

function BoringFPS.DisplayHUDPreGame()
    local timerPreGame = BoringFPS_CONFIG.Settings.TimerPreGame
    local timerStart = false
    local startTimer
    hook.Add( "HUDPaint", "HUDPaint:BoringFPS:HUDPreGame", function()
        if (IsValid(LocalPlayer().TabMenu)) then return end

        local scrW, scrH = BoringFPS_CONFIG.Vars.ScrW, BoringFPS_CONFIG.Vars.ScrH
        BoringFPS.DrawClassSelect(scrW, scrH)
        BoringFPS.DrawInfoPreGame(scrW, scrH)
        BoringFPS.DrawVersionGamemode(scrW, scrH)
        BoringFPS.DrawLevelExperience(scrW, scrH)
        if (GetGlobalBool("IsStartTimerPreGame")) then
            ct = CurTime()
            startTimer = timerStart and startTimer or (ct + timerPreGame)
            timerStart = true
            BoringFPS.DrawTimerLeft(scrW, scrH, math.Round(startTimer - ct))
        else
            timerStart = false --? Pas ouf mais flemme
        end
    end)
end

function BoringFPS.StopHUDPreGame()
    hook.Remove( "HUDPaint", "HUDPaint:BoringFPS:HUDPreGame" )
end

function BoringFPS.DrawLevelExperience(scrW, scrH)
    local ply = LocalPlayer()
    local rectW, rectH = scrW * 0.10, scrH * 0.07
    local rectX, rectY = scrW * 0.01, scrH * 0.01
    local bgColor = Color(0, 0, 0, 200)
    local outlineColor = Color(255, 255, 255)
    local level = ply:GetNWInt("Level", 0)
    local experience = ply:GetNWInt("Exp", 0)
    local expToNextLevel = (differenceExp / 2) * level * (level + 1)
    local expToPreviousLevel = (differenceExp / 2) * (level - 1) * level
    local experiencePerc = math.Round((experience - expToPreviousLevel) / (expToNextLevel - expToPreviousLevel) * 100, 1)
    local wPercent = rectW * 0.4

    BoringFPS.DrawRoundedOutlinedBox(0, rectX, rectY, rectW, rectH, 2, bgColor, outlineColor)
    surface.SetFont("TabHUDSmall")
    local lineWidth, lineHeight = surface.GetTextSize("Lv")
    draw.DrawText("Lv", "TabHUDSmall", rectX + rectW * 0.1, rectY + rectH * 0.3, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    draw.DrawText(level, "LevelFont", rectX + rectW * 0.08 + lineWidth, rectY + rectH * 0.22, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    draw.DrawText(experiencePerc .. "%", "LevelFont", rectX + rectW * 0.6 + lineWidth, rectY + rectH * 0.23, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    draw.RoundedBox(0, rectX + rectW * 0.5, rectY + rectH * 0.68, wPercent, rectH * 0.1, Color(156, 0, 0))
    draw.RoundedBox(0, rectX + rectW * 0.5, rectY + rectH * 0.68, wPercent * (experiencePerc / 100), rectH * 0.1, Color(255, 255, 255))
end

function BoringFPS.DrawClassSelect(scrW, scrH)
    surface.SetDrawColor(255, 255, 255)
    surface.DrawRect(scrW * 0.87, scrH * 0.75, scrW * 0.1, scrH * 0.2)
    surface.SetDrawColor(0, 0, 0)
    surface.DrawRect(scrW * 0.875, scrH * 0.76, scrW * 0.09, scrH * 0.15)
    BoringFPS.DrawIconHud(BoringFPS_CONFIG.Settings.IconsClass[LocalPlayer():GetNWString("ClassWeapon")], scrW * 0.896, scrH * 0.795, Color(255, 255, 255), scrW * 0.05, scrW * 0.05)
    draw.DrawText("Current Class", "NickAnton", scrW * 0.92, scrH * 0.91, Color(0, 0, 0), TEXT_ALIGN_CENTER)
end

function BoringFPS.DrawInfoPreGame(scrW, scrH)
    local rectW, rectH = scrW * 0.10, scrH * 0.07
    local rectX, rectY = scrW - rectW - 10, 10
    local bgColor = Color(0, 0, 0, 200)
    local outlineColor = Color(255, 255, 255)

    BoringFPS.DrawRoundedOutlinedBox(0, rectX, rectY, rectW, rectH, 2, bgColor, outlineColor)

    local text = GetGlobalString("CurrentGameState", "")
    local font = "InfoPregameFont"
    local lines = BoringFPS.WrapText(text, font, rectW - 8)

    surface.SetFont(font)

    local _, lineHeight = surface.GetTextSize("Ay")
    local totalTextHeight = #lines * lineHeight
    local startY = rectY + (rectH / 2) - (totalTextHeight / 2)

    for i, line in ipairs(lines) do
        local y = startY + (i - 1) * lineHeight
        draw.DrawText(line, font, rectX + rectW / 2, y, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end
end

net.Receive(BoringFPS_CONFIG.NetVar.StartClientPreGame, function()
    BoringFPS.DisplayHUDPreGame()
end)

net.Receive(BoringFPS_CONFIG.NetVar.StopClientPreGame, function()
    BoringFPS.StopHUDPreGame()
end)