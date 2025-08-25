net.Receive(BoringFPS_CONFIG.NetVar.SetGlobalTable, function()
    local tbl = net.ReadTable()
    local key = net.ReadString()
    BoringFPS_CONFIG[key] = tbl
end)