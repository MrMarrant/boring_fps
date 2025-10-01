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

if (not BoringFPS_CONFIG.SQL.UseDatabase) then return end

-- Init SQL Data Base
local TablePlayer = BoringFPS_CONFIG.SQL.TablePlayer
local TableClassStat = BoringFPS_CONFIG.SQL.TableClassStat
if not sql.TableExists(TablePlayer) then
    print("[BORINGFPS] Begin create '" .. TablePlayer .. "' table ...")
    local query = [[
        CREATE TABLE ]] .. TablePlayer .. [[ (
            id VARCHAR PRIMARY KEY NOT NULL,
            level INTEGER NOT NULL DEFAULT 1,
            exp INTEGER NOT NULL DEFAULT 0,
            death INTEGER NOT NULL DEFAULT 0,
            kill INTEGER NOT NULL DEFAULT 0,
            damage INTEGER NOT NULL DEFAULT 0,
            movement_done INTEGER NOT NULL DEFAULT 0,
            action_done INTEGER NOT NULL DEFAULT 0,
            dash_done INTEGER NOT NULL DEFAULT 0,
            turn_done INTEGER NOT NULL DEFAULT 0,
            win INTEGER NOT NULL DEFAULT 0
        );
    ]]

    local result = BoringFPS.CreateQuery(query)
    if result == false then
        print("[BORINGFPS] Error during creation table '" .. TablePlayer .. "'")
    else
        print("[BORINGFPS] Table '" .. TablePlayer .. "' was created.")
    end
end

if not sql.TableExists(TableClassStat) then
    print("[BORINGFPS] Begin create '" .. TableClassStat .. "' table ...")
    local query = [[
        CREATE TABLE ]] .. TableClassStat .. [[ (
            id INTEGER PRIMARY KEY NOT NULL,
            steamID VARCHAR NOT NULL,
            class_type VARCHAR NOT NULL,
            death INTEGER NOT NULL DEFAULT 0,
            kill INTEGER NOT NULL DEFAULT 0,
            damage INTEGER NOT NULL DEFAULT 0,
            count_select INTEGER NOT NULL DEFAULT 0,
            win INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY(steamID) REFERENCES ]] .. TablePlayer .. [[(id)
        );
    ]]

    local result = BoringFPS.CreateQuery(query)
    if result == false then
        print("[BORINGFPS] Error during creation table '" .. TableClassStat .. "'")
    else
        print("[BORINGFPS] Table '" .. TableClassStat .. "' was created.")
    end
end

-- ============================
-- Hooks for stats
-- ============================
hook.Add("PlayerDeath", "PlayerDeath:BoringFPS:Stats", function(ply, inflictor, attacker)
    if (GetGlobalBool("GameInProgress") and BoringFPS_CONFIG.Vars.PlayersInGame[ply:GetNWInt("NumberTurn")]) then
        if (istable(ply.BFPS_DataStats)) then
            local class = ply:GetNWString("ClassWeapon", "pistol")
            ply:SetDataPlayer("death", (ply.BFPS_DataPlayer["death"] or 0) + 1)
            ply:SetDataStats(class, "death", 1)
        end
        if (istable(attacker.BFPS_DataStats) and BoringFPS_CONFIG.Vars.PlayersInGame[attacker:GetNWInt("NumberTurn")]) then
            local class = attacker:GetNWString("ClassWeapon", "pistol")
            attacker:SetDataPlayer("kill", (attacker.BFPS_DataPlayer["kill"] or 0) + 1)
            attacker:SetDataStats(class, "kill", 1)
            attacker:AddExperience(BoringFPS_CONFIG.Settings.ExperienceGainByKill)
        end
    end
end)

hook.Add("EntityTakeDamage", "EntityTakeDamage:BoringFPS:Stats", function(target, dmginfo)
    local attacker = dmginfo:GetAttacker()
    if (istable(attacker.BFPS_DataStats) and GetGlobalBool("GameInProgress")) then
        if (attacker:IsPlayer() and attacker != target and BoringFPS_CONFIG.Vars.PlayersInGame[attacker:GetNWInt("NumberTurn")]) then
            local damage = math.Round(dmginfo:GetDamage())
            local class = attacker:GetNWString("ClassWeapon", "pistol")
            attacker:SetDataPlayer("damage", (attacker.BFPS_DataPlayer["damage"] or 0) + damage)
            attacker:SetDataStats(class, "damage", damage)
        end
    end
end)

hook.Add("OnNewDataPlayer", "OnNewDataPlayer:BoringFPS:Stats", function(ply, dataName)
    if (istable(ply.BFPS_DataStats) and GetGlobalBool("GameInProgress") and BoringFPS_CONFIG.Vars.PlayersInGame[ply:GetNWInt("NumberTurn")]) then
        local class = ply:GetNWString("ClassWeapon", "pistol")
        ply:SetDataPlayer(dataName, (ply.BFPS_DataPlayer[dataName] or 0) + 1)
        ply:SetDataStats(class, dataName, 1)
    end
end)