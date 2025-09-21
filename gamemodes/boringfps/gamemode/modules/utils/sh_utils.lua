function BoringFPS.GetLowestKey(tbl)
    local lowest = nil
    for k, _ in pairs(tbl) do
        if type(k) == "number" then
            if lowest == nil or k < lowest then
                lowest = k
            end
        end
    end
    return lowest
end