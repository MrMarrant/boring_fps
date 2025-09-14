function BoringFPS.RevealAura(duration, tableEnt, colorAura)
    local entIndex = LocalPlayer():EntIndex()
    timer.Remove("BoringFPS:TimerDurationRevealAura_" .. entIndex)

    colorAura = colorAura or Color( 255, 0, 0 )
    hook.Add( "PreDrawHalos", "BoringFPS:PreDrawHalos:RevealAuraStalker_" .. entIndex, function()
	    halo.Add(tableEnt, colorAura, 5, 5, 2)
    end )
    timer.Create("BoringFPS:TimerDurationRevealAura_" .. entIndex, duration, 1, function()
        hook.Remove("BoringFPS:PreDrawHalos:RevealAuraStalker_" .. entIndex)
    end)
end

net.Receive(BoringFPS_CONFIG.NetVar.SetGlobalTable, function()
    local tbl = net.ReadTable()
    local key = net.ReadString()
    BoringFPS_CONFIG.Vars[key] = tbl
end)

net.Receive(BoringFPS_CONFIG.NetVar.InsertLogs, function()
    local txt = "> " .. net.ReadString()
    table.insert(BoringFPS_CONFIG.Vars.GameLogs, 1, txt)
    if (#BoringFPS_CONFIG.Vars.GameLogs > 100) then
        table.remove(BoringFPS_CONFIG.Vars.GameLogs)
    end
end)