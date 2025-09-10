-- Création du scoreboard personnalisé
hook.Add("ScoreboardShow", "BoringFPS:CustomScoreboard", function()
    if IsValid(g_Scoreboard) then
        g_Scoreboard:SetVisible(true)
        g_Scoreboard:MakePopup()
        g_Scoreboard:Center()
        return true
    end

    -- Fenêtre principale (DFrame)
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
    ruleTitle:SetText("Titre du Scoreboard")
    ruleTitle:SetFont("DermaLarge")
    ruleTitle:SetTextColor(Color(255, 255, 255))
    ruleTitle:SizeToContents()
    ruleTitle:SetContentAlignment(8)
    ruleTitle:Dock(TOP)
    ruleTitle:DockMargin(0, 10, 0, 5)

    local ruleText = vgui.Create("DLabel", ruleComp)
    ruleText:SetText("Voici un bloc de texte centré avec 70% de la largeur du conteneur.\nTu peux y mettre tes règles, infos, etc.")
    ruleText:SetFont("TabHUD")
    ruleText:SetTextColor(Color(255, 255, 255))
    ruleText:Center()
    ruleText:DockMargin(10, 20, 30, 40)
    ruleText:DockPadding(40, 30, 20, 10)
    --ruleText:SetWrap(true)
    --ruleText:SetAutoStretchVertical(true)
    --ruleText:SetWide(ruleComp:GetWide() * 0.5)
    --ruleText:SetContentAlignment(8) -- centre
    ruleText:Dock(FILL)
    --ruleText:DockMargin(0, 10, 0, 5)

    local bottomHeight = frame:GetTall() * 0.7
    local panelWidth = frame:GetWide() / 3

    -- turnComp
    local turnComp = vgui.Create("DPanel", frame)
    turnComp:SetSize(panelWidth, bottomHeight)
    turnComp:SetPos(0, frame:GetTall() * 0.3)
    turnComp.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(48, 57, 47, 225))
    end

    -- outTurnComp
    local outTurnComp = vgui.Create("DPanel", frame)
    outTurnComp:SetSize(panelWidth, bottomHeight)
    outTurnComp:SetPos(panelWidth, frame:GetTall() * 0.3)
    outTurnComp.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(43, 35, 34, 225))
    end

    -- iconComp
    local iconComp = vgui.Create("DPanel", frame)
    iconComp:SetSize(panelWidth, bottomHeight)
    iconComp:SetPos(panelWidth * 2, frame:GetTall() * 0.3)
    iconComp.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(83, 110, 213, 225))
    end

    return true
end)

hook.Add("ScoreboardHide", "BoringFPS:CustomScoreboardHide", function()
    if IsValid(g_Scoreboard) then
        g_Scoreboard:SetVisible(false)
    end
end)
