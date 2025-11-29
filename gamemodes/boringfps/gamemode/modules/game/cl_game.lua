local function CreateHatPlayer(ply, level)
    local modelPath = BoringFPS_CONFIG.Models.HatModels[level]
    local bodygroup = BoringFPS_CONFIG.Models.BodyGroupHat[level]
    if (ply.BFPS_HatModel) then
        if (ply.BFPS_HatModel:GetModel() ~= modelPath) then
            ply.BFPS_HatModel:SetModel( modelPath )
            ply.BFPS_HatModel:SetBodyGroups(bodygroup)
        end
    else
        ply.BFPS_HatModel = ClientsideModel(modelPath)
        local model = ply.BFPS_HatModel
        model:SetBodyGroups(bodygroup)
        model:SetNoDraw( true )
    end
    return ply.BFPS_HatModel
end

local function DisplayVoteMap(maps)
    local timeLeft = BoringFPS_CONFIG.Settings.TimerForVote
    local selectedMap = nil
    local w, h = BoringFPS_CONFIG.Vars.ScrW, BoringFPS_CONFIG.Vars.ScrH

    local frame = vgui.Create("DFrame")
    frame:SetSize(w * 0.2, h * 0.4)
    frame:SetPos(w * 0.05, h * 0.1)
    frame:SetTitle("Vote for next map")
    frame:MakePopup()
    frame:ShowCloseButton(false)

    local list = vgui.Create("DListView", frame)
    list:Dock(FILL)
    list:AddColumn("Maps BFPS")

    for _, map in ipairs(maps) do
        list:AddLine(map)
    end

    list.OnRowSelected = function(_, _, row)
        if (row:GetColumnText(1) == selectedMap) then return end

        selectedMap = row:GetColumnText(1)
        net.Start(BoringFPS_CONFIG.NetVar.VoteMap)
        net.WriteString(selectedMap)
        net.SendToServer()
    end

    timer.Create("MapVoteTimer", 1, 10, function()
        timeLeft = timeLeft - 1
        frame:SetTitle("Time left - " .. timeLeft .. " sec")

        if timeLeft <= 0 then
            frame:Close()
        end
    end)
end

-- Net Receive
net.Receive(BoringFPS_CONFIG.NetVar.StartClientHUDGame, function()
    BoringFPS.DisplayHUDGame()
end)

net.Receive(BoringFPS_CONFIG.NetVar.EndGame, function()
    local congratsMsg = net.ReadString()
    BoringFPS.StopHudGame()
    BoringFPS.DisplayAnnouncerTurn(congratsMsg)
end)

net.Receive(BoringFPS_CONFIG.NetVar.StartClientWait, function()
    local firstTurn = net.ReadBool()
    LocalPlayer():EmitSound(BoringFPS_CONFIG.Sounds.TurnEnd)
    BoringFPS.DisplayAnnouncerTurn(firstTurn and "Game Start" or "TURN END")
end)

net.Receive(BoringFPS_CONFIG.NetVar.StartClientPlay, function()
    LocalPlayer():EmitSound(BoringFPS_CONFIG.Sounds.TurnStart)
    BoringFPS.DisplayHUDPlay()
    BoringFPS.DisplayAnnouncerTurn("YOUR TURN")
    hook.Call("PlayerTurnStart", nil, LocalPlayer())
end)

net.Receive(BoringFPS_CONFIG.NetVar.StopClientTurn, function()
    BoringFPS.StopHudTurn()
end)

net.Receive(BoringFPS_CONFIG.NetVar.ChangeMap, function()
    local maps = net.ReadTable()
    DisplayVoteMap(maps)
end)

-- Hide Base HUD
hook.Add( "HUDShouldDraw", "HUDShouldDraw:BoringFPS:HideHUD", function( name )
	if ( BoringFPS_CONFIG.Settings.HideHUD[ name ] ) then
		return false
	end
end )

-- Hide Base DrawTarget
hook.Add( "HUDDrawTargetID", "BoringFPS:HUDDrawTargetID", function()
	return false
end )

hook.Add("SpawnMenuOpen", "BoringFPS:SpawnMenuOpen", function()
    return LocalPlayer():HasAccess()
end)

hook.Add( "PostPlayerDraw" , "BoringFPS:PostPlayerDraw:DrawHatLevel" , function( ply )
	if IsValid(ply) and ply:Alive() and ply:CanGetData() then
        local level = math.floor(ply:GetNWInt("Level", 0) / 10) * 10
        local model = CreateHatPlayer(ply, level)
        local attach_id = ply:LookupAttachment('eyes')
        if not attach_id then return end
                
        local attach = ply:GetAttachment(attach_id)
                
        if not attach then return end
                
        local pos = attach.Pos
        local ang = attach.Ang

        pos = pos + (ang:Forward() * -3.5)
        pos.z = pos.z + 2

        model:SetPos(pos)
        model:SetAngles(ang)
        model:SetRenderOrigin(pos)
        model:SetRenderAngles(ang)
        model:SetupBones()
        model:DrawModel()
        model:SetRenderOrigin()
        model:SetRenderAngles()

        model:DrawModel()
    end
end )