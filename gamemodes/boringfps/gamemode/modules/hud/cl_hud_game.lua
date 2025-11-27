-- TODO : Revoir le responsive sur petit écran, nottament la taille des éléments
local function RemoveAvatar()
    local ply = LocalPlayer()
    if (table.IsEmpty(ply.ListAvatar)) then return end
    for _, avatar in ipairs(ply.ListAvatar) do
        if IsValid(avatar) then
            avatar:Remove()
        end
    end
end

function BoringFPS.DisplayHUDGame()
    local plyList = BoringFPS_CONFIG.Vars.PlayersInGame
    hook.Add( "HUDPaint", "HUDPaint:BoringFPS:HUDGame", function()
        if (IsValid(LocalPlayer().TabMenu) or IsValid(LocalPlayer().HelpMenu)) then RemoveAvatar() return end

        local scrW, scrH = BoringFPS_CONFIG.Vars.ScrW, BoringFPS_CONFIG.Vars.ScrH
        BoringFPS.DrawListPlayerTurn(scrW, scrH, plyList)
        BoringFPS.DrawHealth(scrW * 0.45, scrH * 0.9)
        BoringFPS.DrawLogs(scrW, scrH)
        BoringFPS.DrawGlobalTurn(scrW, scrH)
        BoringFPS.DrawVersionGamemode(scrW, scrH)
        if (GetGlobalBool("EndGameEnabled", false)) then
            local cycle = BoringFPS.Oscillate(1.5, 5, 8)
            BoringFPS.DrawRoundedOutlinedBox(0, 0, 0, scrW, scrH, cycle, Color(0, 0, 0, 0), Color(63, 0, 0))
        end
    end)
end

function BoringFPS.DrawListPlayerTurn(scrW, scrH, plyList)
    for index, ply in ipairs(plyList) do
        if (IsValid(ply)) then
            BoringFPS.DrawPlayerTurn(ply, index, scrH, scrW)
        else
            BoringFPS.DrawEmptyPlayer(index, scrH, scrW)
        end
    end
end

function BoringFPS.DrawGlobalTurn(scrW, scrH)
    local colorTxt = Color(255, 255, 255)
    draw.SimpleText(BoringFPS.GetTranslation("turn", GetGlobalInt("GlobalTurn", 1)), "NickAnton", scrW * 0.82, scrH * 0.08, colorTxt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function BoringFPS.DrawPlayerTurn(ply, index, scrH, scrW)
    local indexDirectionTurn = GetGlobalInt("CurrentIndexDirectionTurn", 0)
    local baseHeight = scrH * 0.06
    local baseWidth  = scrW * 0.15
    local spacing    = 10
    local startX = scrW * 0.82
    local startY = scrH * 0.1
    local colorTxt = Color(255, 255, 255)
    local wIcon, hIcon = baseHeight * 0.6, baseHeight * 0.6
    local posY = startY + (index - 1) * (baseHeight + spacing)
    local colorBG = index == indexDirectionTurn and Color(83, 109, 213, 230) or Color(10, 10, 10, 150)
    local clientPly = LocalPlayer()
    clientPly.ListAvatar = clientPly.ListAvatar or {}
    colorBG = ply:Alive() and colorBG or Color(160, 0, 0, 150)

    draw.RoundedBox(0, startX, posY, baseWidth, baseHeight, colorBG)
    draw.SimpleText(index, "NickAnton", startX + 10, posY + baseHeight / 2, colorTxt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    local avatarSize = baseHeight * 0.7
    local avatarX = startX + baseWidth * 0.1
    local avatarY = posY + (baseHeight - avatarSize) / 2

    if not IsValid(clientPly.ListAvatar[index]) then
        clientPly.ListAvatar[index] = vgui.Create("AvatarImage")
        clientPly.ListAvatar[index]:SetPlayer(ply, 64)
        clientPly.ListAvatar[index]:SetSize(avatarSize, avatarSize)
    end
    clientPly.ListAvatar[index]:SetPos(avatarX, avatarY)
    clientPly.ListAvatar[index]:SetSize(avatarSize, avatarSize)

    local nameX = avatarX + avatarSize + 10
    local maxWidthName = baseWidth * 0.7 - (nameX - startX) - 5
    local maxWidth = baseWidth - (nameX - startX) - 5

    local playerName = BoringFPS.TruncatedText(ply:Nick(), "NickAnton", maxWidth)

    draw.SimpleText(playerName, "NickAnton", nameX, posY + baseHeight / 2, colorTxt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    nameX = nameX + maxWidth - baseWidth * 0.3
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(BoringFPS_CONFIG.Icons.HeartFillIcon)
    surface.DrawTexturedRect(nameX, posY + baseHeight * 0.25, wIcon, hIcon)
    nameX = nameX + wIcon + baseWidth * 0.03
    draw.SimpleText(math.Clamp(ply:Health(), 0, ply:GetMaxHealth()), "NickAnton", nameX, posY + baseHeight / 2, colorTxt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function BoringFPS.DrawEmptyPlayer(index, scrH, scrW)
    local baseHeight = scrH * 0.06
    local baseWidth  = scrW * 0.15
    local spacing    = 10
    local startX = scrW * 0.82
    local startY = scrH * 0.1
    local colorTxt = Color(255, 255, 255)
    local wIcon, hIcon = baseHeight * 0.6, baseHeight * 0.6
    local posY = startY + (index - 1) * (baseHeight + spacing)
    local colorBG = Color(160, 0, 0, 150)

    draw.RoundedBox(0, startX, posY, baseWidth, baseHeight, colorBG)
    draw.SimpleText(index, "NickAnton", startX + 10, posY + baseHeight / 2, colorTxt, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(BoringFPS_CONFIG.Icons.DisconnectedIcon)
    surface.DrawTexturedRect(startX + baseWidth * 0.5, posY + baseHeight * 0.25, wIcon, hIcon)
end

function BoringFPS.StopHudGame()
    hook.Remove( "HUDPaint", "HUDPaint:BoringFPS:HUDGame" )
    RemoveAvatar()
end

function BoringFPS.DisplayHUDPlay()
    local timeLimit = GetGlobalInt("CurrentLimitTimer", BoringFPS_CONFIG.Settings.LimitTimeTurn)
    local startTime = CurTime() + timeLimit

    hook.Add( "HUDPaint", "HUDPaint:BoringFPS:HUDTurn", function()
        BoringFPS.DrawTimerLeft(BoringFPS_CONFIG.Vars.ScrW, BoringFPS_CONFIG.Vars.ScrH, math.Round(startTime - CurTime()))
    end )
end

function BoringFPS.DisplayAnnouncerTurn(text)
    local w, h = BoringFPS_CONFIG.Vars.ScrW, BoringFPS_CONFIG.Vars.ScrH

    hook.Add( "HUDPaint", "HUDPaint:BoringFPS:HUDAnnouncerTurn", function()
        draw.DrawText(text, "AnnouncerTurn", w * 0.5, h * 0.3, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    end )
    timer.Create("BoringFPS:TimerAnnouncerTurn", BoringFPS_CONFIG.Settings.DurationAnnouncerTurn, 1, function()
        hook.Remove( "HUDPaint", "HUDPaint:BoringFPS:HUDAnnouncerTurn" )
    end)
end

function BoringFPS.StopHudTurn()
    hook.Remove( "HUDPaint", "HUDPaint:BoringFPS:HUDTurn" )
end

function BoringFPS.DrawTimerLeft(scrW, scrH, timeLeft)
    local x , y = BoringFPS_CONFIG.Vars.ScrW * 0.5, BoringFPS_CONFIG.Vars.ScrH * 0.08
    local colorTimer = timeLeft > 3 and Color(255, 255, 255) or Color(255, 0, 0)
    local xIcon, yIcon = x - scrW * 0.023, y - scrH * 0.023
    BoringFPS.DrawIconHud(BoringFPS_CONFIG.Icons.CircleIcon, xIcon - scrW * 0.011, yIcon - scrH * 0.033, Color(255, 255, 255), scrW * 0.07, scrW * 0.07)
    BoringFPS.DrawIconHud(BoringFPS_CONFIG.Icons.CircleIcon, xIcon - scrW * 0.0065, yIcon - scrH * 0.023, Color(0, 0, 0), scrW * 0.06, scrW * 0.06)
    draw.DrawText(timeLeft, "HudTimerLeft", x, y - 45, colorTimer, TEXT_ALIGN_CENTER)
end

function BoringFPS.DrawHealth(x, y)
    local health = LocalPlayer():Health()
    local w, h = 64, 64
    local yIcon = y + 15

    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(BoringFPS_CONFIG.Icons.HeartIcon)
    surface.DrawTexturedRect(x, yIcon, w, h)

    if health > 0 then
        local percent = math.Clamp(health, 0, 100) / 100
        local fillHeight = h * percent

        render.SetScissorRect(x, yIcon + (h - fillHeight), x + w, yIcon + h, true)
            surface.SetDrawColor(255, 0, 0, 180)
            surface.SetMaterial(BoringFPS_CONFIG.Icons.HeartFillIcon)
            surface.DrawTexturedRect(x, yIcon, w, h)
        render.SetScissorRect(0, 0, 0, 0, false)
    end
    draw.DrawText(health, "HudTimerLeft", x + 100, y, Color(255, 255, 255), TEXT_ALIGN_CENTER)
end

function BoringFPS.DrawLogs(scrW, scrH)
    local x, y = scrW * 0.02, scrH * 0.65
    local baseW, baseH = scrW * 0.15, scrH * 0.31
    local lineHeight = scrH * 0.025
    local marginX, marginY = scrW * 0.01, scrH * 0.01

    draw.RoundedBox(0, x, y, baseW, baseH, Color(0, 0, 0, 200))
    surface.SetDrawColor(255, 255, 255)
    surface.DrawOutlinedRect(x, y, baseW, baseH)

    render.SetScissorRect(x, y, x + baseW, y + baseH, true)

    surface.SetFont("Default")
    local yOffset = y + marginY
    for i, txt in ipairs(BoringFPS_CONFIG.Vars.GameLogs) do
        draw.DrawText( txt, "Default", x + marginX, yOffset, Color(255, 255, 255), TEXT_ALIGN_LEFT )
        yOffset = yOffset + lineHeight
    end

    render.SetScissorRect(0, 0, 0, 0, false)
end

function BoringFPS.DrawDashHud(x, y, value, maxValue)
    local sizeTriangle = 20
    local startX = x + 50

    BoringFPS.DrawIconHud(BoringFPS_CONFIG.Icons.DashIcon, x, y)
    draw.DrawText(math.Clamp(value, 0, maxValue), "HudBoringFPS", startX, y - 10, Color(255, 255, 255), TEXT_ALIGN_CENTER)

    startX = startX + 50
    BoringFPS.DrawTriangle(startX, y, value, maxValue, sizeTriangle, 30)
end

function BoringFPS.DrawActionLeft(x, y, value, maxValue)
    local squareW = 30 * (4 / maxValue)
    local squareH = 25
    local startX = x + 50

    BoringFPS.DrawIconHud(BoringFPS_CONFIG.Icons.ActionIcon, x, y)
    draw.DrawText(math.Clamp(value, 0, maxValue), "HudBoringFPS", startX, y - 10, Color(255, 255, 255), TEXT_ALIGN_CENTER)

    startX = startX + 25
    BoringFPS.DrawSquare(startX, y, value, maxValue, squareW, squareH, 20)
end

function BoringFPS.DrawStepLeftHUD(x, y, value, maxValue)
    local maxX = BoringFPS_CONFIG.Vars.ScrW
    local squareSize = 20 * (10 / maxValue)
    local startX = x + 50

    BoringFPS.DrawIconHud(BoringFPS_CONFIG.Icons.StepIcon, x, y)
    draw.DrawText(math.Clamp(value, 0, maxValue), "HudBoringFPS", startX, y - 10, Color(255, 255, 255), TEXT_ALIGN_CENTER)

    startX = startX + 25
    BoringFPS.DrawSquare(startX, y, value, maxValue, squareSize, squareSize, 1)
end