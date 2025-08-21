function BoringFPS.PrintToAllPlayers(msg, typeMsg)
    for _, ply in ipairs(player.GetAll()) do
        ply:PrintMessage( typeMsg, msg )
    end
end

function BoringFPS.CountdownTimer(duration)
    local timeLeft = duration - 1

    timer.Create("BoringFPS:CountdownTimer", 1, duration, function()
        BoringFPS.PrintToAllPlayers("Game starts in " .. timeLeft .. " seconds...", HUD_PRINTCENTER)
        timeLeft = timeLeft - 1
    end)
end

function BoringFPS.EnterSpectatorMode(ply)
    ply:Spectate(OBS_MODE_CHASE)

    local target = BoringFPS.FindNextAlivePlayer(ply)
    if (IsValid(target)) then
        ply:SpectateEntity(target)
    end
end

function BoringFPS.FindNextAlivePlayer(ply, currentTarget)
    local players = BoringFPS_CONFIG.PlayersAlive
    local currentKey = currentTarget and table.KeyFromValue(players, currentTarget) or 0
    local newKey = currentKey + 1

        if newKey > #players then
            newKey = 1
        end
    return players[newKey]
end

function BoringFPS.SetGlobalTable(tbl, key)
    BoringFPS_CONFIG[key] = tbl
    print("Liste des joueurs en jeu SERVER :")
    PrintTable(tbl)
    local ParsedTable = {}
    for k, v in ipairs(player.GetAll()) do
        ParsedTable[k] = { v }
    end
    print("JASON : ")
    print(util.TableToJSON(ParsedTable)) -- TODO : Renvoie un tableau vide 
    net.Start(BoringFPS_CONFIG.NetVar.SetGlobalTable)
    net.WriteString(util.TableToJSON(ParsedTable))
    net.WriteString(key)
    net.Broadcast()
end

function BoringFPS.GetWantedMoveDirection(ply)
    local moveDir = Vector(0, 0, 0)

    if ply:KeyDown(IN_FORWARD) then
        moveDir = moveDir + ply:GetForward()
    end
    if ply:KeyDown(IN_BACK) then
        moveDir = moveDir - ply:GetForward()
    end
    if ply:KeyDown(IN_MOVELEFT) then
        moveDir = moveDir - ply:GetRight()
    end
    if ply:KeyDown(IN_MOVERIGHT) then
        moveDir = moveDir + ply:GetRight()
    end

    moveDir.z = 0

    return moveDir:GetNormalized()
end

function BoringFPS.ShuffleTable(t)
    local len = #t
    for i = len, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

hook.Add( "PlayerDeathThink", "PlayerDeathThink:BoringFPS:SpectatorNext", function( ply )
    if ply:GetObserverMode() == OBS_MODE_CHASE then
        if ply:KeyPressed( IN_ATTACK ) then
            local nextTarget = BoringFPS.FindNextAlivePlayer(ply, ply:GetObserverTarget())
            if IsValid(nextTarget) then
                ply:SpectateEntity(nextTarget)
            end
        end
        return false
    end
end )