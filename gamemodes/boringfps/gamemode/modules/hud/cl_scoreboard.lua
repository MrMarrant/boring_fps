-- Vars
local plyListW, plyListH = 0.2, 0.95     -- Size box
local patchW, patchH = 0.58, 0.8     -- Size box
local cornerRadius = 12          -- Roundness level
local margin = 50                -- Internal margin
local avatarSize = 40              -- Icon size

local function CreatePatchContainer(frame, scrW, scrH, x, y)
    local sizePatchW = scrW * patchW
    local sizePatchH = scrH * patchH
    local html = vgui.Create("DHTML", frame)
    html:SetPos(x, y)
    html:SetSize(sizePatchW, sizePatchH)
    html:SetHTML(BoringFPS_CONFIG.Vars.LastPatch)
end

local function CreatePlayerListContainer(frame, scrW, scrH, x, y)
    local sizeplyListW = scrW * plyListW
    local sizeplyListH = scrH * plyListH

    local BannerImg = vgui.Create("DImage", frame)
    BannerImg:SetPos(scrW * 0.82, scrH * 0.02)
    BannerImg:SetSize(300, 150)
    BannerImg:SetImage("boringfps/icons/boringpfs_banner.png")

    local DScrollPanel = vgui.Create( "DScrollPanel", frame )
    DScrollPanel:SetPos(x, y)
    DScrollPanel:SetSize(sizeplyListW, sizeplyListH)
    local ScrollBar = DScrollPanel:GetVBar()
    ScrollBar:SetWide(3)
    ScrollBar.btnGrip.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 93, 129, 156))
    end

    for key, ply in ipairs(player.GetAll()) do
        local DPanel = vgui.Create( "DPanel", DScrollPanel)
        DPanel:SetSize( 0, 70 )
        DPanel:Dock( TOP )
        DPanel:DockMargin( 20, 20, 20, 10 )

        local avatar = vgui.Create("AvatarImage", DPanel)
        avatar:SetPlayer(ply, 64)
        avatar:SetSize(avatarSize, avatarSize)
        avatar:SetPos(5, DPanel:GetTall() * 0.5 - avatarSize / 2)

        local wAvatar, hAvatar = avatar:GetSize()
        DPanel.Paint = function(self, w, h)
            local ping = ply:Ping()
            draw.RoundedBox(0, 0, 0, w, h, Color(248, 248, 248))
            draw.SimpleText(BoringFPS.TruncatedText(ply:Nick(), "NickAnton", w * 0.5), "NickAnton", wAvatar + w * 0.05, h / 2, Color(3, 3, 3), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(ping, "NickAnton", wAvatar + w * 0.6, h / 2, ping > 100 and Color(109, 0, 0) or Color(0, 97, 40), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
end

local function CreateScoreBoardHUD()
    local scrW, scrH = BoringFPS_CONFIG.Vars.ScrW, BoringFPS_CONFIG.Vars.ScrH
    local plyListX = scrW * 0.02
    local plyListY = scrH * 0.02
    local patchX = scrW * 0.4
    local patchY = scrH * 0.18
    local frame = vgui.Create("DFrame")

    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame:SetSizable(false)
    frame:SetDeleteOnClose(false)
    frame:SetSize(scrW, scrH)
    frame:Center()
    frame:MakePopup()
    frame.Paint = function(self, w, h)
        surface.SetDrawColor(0, 0, 0, 100)
        surface.DrawRect(0, 0, w, h)
        BoringFPS.DrawRoundedOutlinedBox(cornerRadius, plyListX, plyListY, scrW * plyListW, scrH * plyListH, Color(0, 0, 0, 150), color_white)
        BoringFPS.DrawRoundedOutlinedBox(cornerRadius, patchX, patchY, scrW * patchW, scrH * patchH, Color(0, 0, 0, 206), color_white)
    end

    CreatePatchContainer(frame, scrW, scrH, patchX, patchY)
    CreatePlayerListContainer(frame, scrW, scrH, plyListX, plyListY)
    LocalPlayer().TabMenu = frame
end

hook.Add("ScoreboardShow", "BoringFPS:CustomScoreboard", function()
    local lply = LocalPlayer()
    if IsValid(lply.TabMenu) then
        lply.TabMenu:SetVisible(true)
        lply.TabMenu:MakePopup()
        lply.TabMenu:Center()
        return true
    end

    CreateScoreBoardHUD()
    return true
end)

hook.Add("ScoreboardHide", "BoringFPS:CustomScoreboardHide", function()
    local lply = LocalPlayer()
    if (IsValid(lply.TabMenu)) then
        lply.TabMenu:Remove()
        lply.TabMenu = nil
    end
end)
