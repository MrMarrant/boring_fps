local function CreateHatPlayer(ply)
    local index = math.floor(1 / 10) * 10
    local modelPath = BoringFPS_CONFIG.Models.HatModels[index]
    local model
    if (ply.BFPS_HatModel) then
        if (ply.BFPS_HatModel:GetModel() != modelPath) then
            ply.BFPS_HatModel:Remove()
            ply.BFPS_HatModel = ClientsideModel(modelPath)
            model = ply.BFPS_HatModel
        else
            model = ply.BFPS_HatModel
        end
    else
        ply.BFPS_HatModel = ClientsideModel(modelPath)
        model = ply.BFPS_HatModel
    end
    return model
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
	if not IsValid(ply) or not ply:Alive() then return end

    local model = CreateHatPlayer(ply)
	local attach_id = ply:LookupAttachment('eyes')
	if not attach_id then return end
			
	local attach = ply:GetAttachment(attach_id)
			
	if not attach then return end
			
	local pos = attach.Pos
	local ang = attach.Ang

	pos = pos + (ang:Forward() * -4.5)
	pos.z = pos.z + 1.7
	ang:RotateAroundAxis(ang:Right(), 20)
		
	model:SetPos(pos)
	model:SetAngles(ang)

	model:SetRenderOrigin(pos)
	model:SetRenderAngles(ang)
	model:SetupBones()
	model:DrawModel()
	model:SetRenderOrigin()
	model:SetRenderAngles()

end )