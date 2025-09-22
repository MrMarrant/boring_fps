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

function BoringFPS.TableShrink(tbl, quantity, fromBegin)
    fromBegin = fromBegin or false
    for var = 1, quantity do
        if (fromBegin) then
            table.remove(tbl, 1)
        else
            table.remove(tbl)
        end
    end

    return tbl
end

function table.ShuffleSequential(t)
    local len = #t
    for i = len, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end