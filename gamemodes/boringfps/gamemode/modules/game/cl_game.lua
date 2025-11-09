local function CreateHatPlayer(ply, level)
    local modelPath = BoringFPS_CONFIG.Models.HatModels[level]
    local bodygroup = BoringFPS_CONFIG.Models.BodyGroupHat[level]
    if (ply.BFPS_HatModel) then
        if (ply.BFPS_HatModel:GetModel() != modelPath) then
            ply.BFPS_HatModel:SetModel( modelPath )
            ply.BFPS_HatModel:SetBodyGroups(bodygroup)
        end
    else
        ply.BFPS_HatModel = ClientsideModel(modelPath)
        model = ply.BFPS_HatModel
        model:SetBodyGroups(bodygroup)
        model:SetNoDraw( true )
    end
    return ply.BFPS_HatModel
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