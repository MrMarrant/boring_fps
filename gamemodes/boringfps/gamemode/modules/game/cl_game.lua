function BoringFPS.PlaySound(sound, loop)
    local ply = LocalPlayer()
    if (loop) then
        ply:StartLoopingSound(sound)
    else
        ply:EmitSound(sound, 150)
    end
end

function BoringFPS.StopSound(sound)
    local ply = LocalPlayer()
    ply:StopSound(sound)
end

function BoringFPS.StopSound(sound)
    local ply = LocalPlayer()
    ply:StopSound(sound)
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
    LocalPlayer():EmitSound(BoringFPS_CONFIG.Sounds.TurnEnd)
    BoringFPS.DisplayHUDWait()
    BoringFPS.DisplayAnnouncerTurn("TURN END")
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

net.Receive(BoringFPS_CONFIG.NetVar.PlayClientSound, function()
    local soundToPlay = net.ReadString()
    local isLoop = net.ReadBool()
    BoringFPS.PlaySound(soundToPlay, isLoop)
end)

net.Receive(BoringFPS_CONFIG.NetVar.StopPlayClientSound, function()
    local soundToStop = net.ReadString()
    BoringFPS.StopSound(soundToStop)
end)

-- Hide Base HUD
hook.Add( "HUDShouldDraw", "HUDShouldDraw:BoringFPS:HideHUD", function( name )
	if ( BoringFPS_CONFIG.Settings.HideHUD[ name ] ) then
		return false
	end
end )