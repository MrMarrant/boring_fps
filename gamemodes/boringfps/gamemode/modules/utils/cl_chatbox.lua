-- ============================
-- Custom Chatbox for Boring FPS
-- ============================

local ChatFrame, ChatLog, ChatEntry
local IsTeamChat = false --? Not use for now
local ScrW, ScrH = BoringFPS_CONFIG.Vars.ScrW, BoringFPS_CONFIG.Vars.ScrH
local x, y = ScrW * 0.01, ScrH * 0.43
local ChatHistory = {}
local DisplayMessages = true
local MessageLifetime = BoringFPS_CONFIG.Settings.MessageLifetimeChatBox

--[[
* Open the chat box.
* @bool teamChat Is the message intended for a team.
--]]
local function OpenChat(teamChat)
    if not IsValid(ChatFrame) then return end

    IsTeamChat = teamChat or false
    ChatFrame:SetVisible(true)
    ChatFrame:MakePopup()
    ChatEntry:RequestFocus()

    DisplayMessages = false
end

--[[
* Close the chat box.
--]]
local function CloseChat()
    if not IsValid(ChatFrame) then return end

    ChatFrame:SetVisible(false)
    gui.HideGameUI()

    DisplayMessages = true
end

--[[
* Add message into the table history of chatbox.
* @string msg The message text.
* @Color col The color message.
--]]
local function AddToHistory(msg, col)
    table.insert(ChatHistory, {text = msg, col = col or Color(255,255,255), time = CurTime()})
    if #ChatHistory > 7 then
        table.remove(ChatHistory, 1)
    end
end

--[[
* Create the chatbox base.
--]]
hook.Add("InitPostEntity", "InitPostEntity:BoringFPS:CreateChatBox", function()
    ChatFrame = vgui.Create("DFrame")
    ChatFrame:SetSize(ScrW * 0.28, ScrH * 0.2)
    ChatFrame:SetPos(x, y)
    ChatFrame:SetTitle("Boring Chat")
    ChatFrame:SetVisible(false)
    ChatFrame:SetDraggable(false)
    ChatFrame:ShowCloseButton(false)

    ChatFrame.Paint = function(self, w, h)
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawRect(0, 0, w, h)
    end

    ChatLog = vgui.Create("RichText", ChatFrame)
    ChatLog:Dock(FILL)
    function ChatLog:PerformLayout()
        self:SetFontInternal("ChatFont")
        self:SetBGColor(Color(0,0,0,0))
    end

    ChatEntry = vgui.Create("DTextEntry", ChatFrame)
    ChatEntry:Dock(BOTTOM)
    ChatEntry:SetTall(25)
    ChatEntry:SetText("")
    ChatEntry.OnEnter = function(self)
        local text = self:GetText()
        if text ~= "" then
            if IsTeamChat then
                RunConsoleCommand("say_team", text)
            else
                RunConsoleCommand("say", text)
            end
        end
        self:SetText("")
        CloseChat()
    end
end)

--[[
* Manage open chatbox
--]]
hook.Add("PlayerBindPress", "PlayerBindPress:BoringFPS:CustomChatboxBinds", function(ply, bind, pressed)
    if not pressed then return end
    if string.find(bind, "messagemode2") then
        OpenChat(true)
        return true
    elseif string.find(bind, "messagemode") then
        OpenChat(false)
        return true
    end
end)

--[[
* Message system (join/leave).
--]]
hook.Add("ChatText", "ChatText:BoringFPS:CustomChatboxText", function(_, _, text, type)
    if not IsValid(ChatLog) then return end
    if type == "joinleave" or type == "none" or type == "chat" then
        ChatLog:InsertColorChange(255, 255, 255, 255)
        ChatLog:AppendText(text .. "\n")
        AddToHistory(text, Color(200,200,200))
    end
end)

--[[
* Message system PlayerChat.
--]]
hook.Add("OnPlayerChat", "OnPlayerChat:BoringFPS:CustomChatboxOnPlayerChat", function(ply, text, teamChat, isDead)
    if not IsValid(ChatLog) then return end

    local prefix = ""
    if isDead then prefix = "*DEAD* " end
    -- if teamChat then prefix = prefix .. "(TEAM) " end

    local finalMsg = prefix .. ply:Nick() .. ": " .. text

    ChatLog:InsertColorChange(200, 200, 200, 255)
    ChatLog:AppendText(finalMsg .. "\n")

    AddToHistory(finalMsg, Color(255,255,255))

    return true
end)

--[[
* Text message history outside chatbox.
--]]
hook.Add("HUDPaint", "HUDPaint:BoringFPS:CustomChatboxHUDPaint", function()
    if not DisplayMessages or not IsValid(ChatFrame) then return end

    local chatPosX, chatPosY = ChatFrame:GetPos()
    local chatSizeW, chatSizeH = ChatFrame:GetSize()
    local offsetY = ScrH * 0.0176
    chatPosX = chatPosX + ScrW * 0.004
    chatPosY = chatPosY + ScrH * 0.027

    local font = "ChatFont"
    surface.SetFont(font)

    for i, msg in ipairs(ChatHistory) do
        local timePassed = CurTime() - msg.time
        if timePassed < MessageLifetime then
            local alpha = 255
            if timePassed > MessageLifetime - 2 then
                alpha = math.Clamp(255 - (timePassed - (MessageLifetime - 2)) * 127, 0, 255)
            end

            local col = Color(msg.col.r, msg.col.g, msg.col.b, alpha)
            draw.SimpleText(msg.text, font, chatPosX, chatPosY + offsetY * (i - 1) , col, TEXT_ALIGN_LEFT)
        end
    end
end)
