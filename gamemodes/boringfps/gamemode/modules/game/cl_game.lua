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