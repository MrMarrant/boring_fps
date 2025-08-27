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