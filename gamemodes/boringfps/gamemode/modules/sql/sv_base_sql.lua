function BoringFPS.PrintSQLErrors(sql)
    sql.m_strError = nil -- This is required to invoke __newindex

    setmetatable( sql, { __newindex = function( table, k, v )
        if ( k == "m_strError" and v and #v > 0 ) then
            print("[SQL Error] " .. v )
        end
    end } )
end

function BoringFPS.CreateQuery(query)
    local result = sql.Query(query)
    -- TODO : log the query without print to all players
    if result == false then
        print("[BORINGFPS] Error during query :")
        BoringFPS.PrintSQLErrors(sql)
    else
        print("[BORINGFPS] Query was executed :")
        print(query)
    end
    return result
end

-- Init SQL Data Base
local TablePlayer = BoringFPS_CONFIG.SQL.TablePlayer
if not sql.TableExists(BoringFPS_CONFIG.SQL.TablePlayer) then
    print("[BORINGFPS] Begin create '" .. TablePlayer .. "' table ...")
    local query = [[
        CREATE TABLE ]] .. TablePlayer .. [[ (
            id VARCHAR PRIMARY KEY NOT NULL,
            level INTEGER NOT NULL DEFAULT 1,
            exp INTEGER NOT NULL DEFAULT 0,
            death INTEGER NOT NULL DEFAULT 0,
            kill INTEGER NOT NULL DEFAULT 0,
            damage INTEGER NOT NULL DEFAULT 0,
            bullet_shot INTEGER NOT NULL DEFAULT 0,
            movement_done INTEGER NOT NULL DEFAULT 0,
            action_done INTEGER NOT NULL DEFAULT 0,
            dash_done INTEGER NOT NULL DEFAULT 0,
            turn_done INTEGER NOT NULL DEFAULT 0,
            win INTEGER NOT NULL DEFAULT 0,
            defeat INTEGER NOT NULL DEFAULT 0
        );
    ]]

    local result = BoringFPS.CreateQuery(query)
    if result == false then
        print("[BORINGFPS] Error during creation table '" .. TablePlayer .. "'")
    else
        print("[BORINGFPS] Table '" .. TablePlayer .. "' was created.")
    end
end