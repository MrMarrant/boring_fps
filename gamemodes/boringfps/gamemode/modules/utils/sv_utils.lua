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
    BoringFPS_CONFIG.Vars[key] = tbl

    net.Start(BoringFPS_CONFIG.NetVar.SetGlobalTable)
    net.WriteTable(tbl)
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

    moveDir = moveDir == Vector(0, 0, 0) and ply:GetForward() or moveDir
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

function BoringFPS.InsertLogs(txt)
    table.insert(BoringFPS_CONFIG.Vars.GameLogs, 1, txt)
    net.Start(BoringFPS_CONFIG.NetVar.InsertLogs)
    net.WriteString(txt)
    net.Broadcast()
    if (#BoringFPS_CONFIG.Vars.GameLogs > 100) then
        table.remove(BoringFPS_CONFIG.Vars.GameLogs)
    end
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

-- TODO : Notifier quand un joueur meurt/touché

hook.Add( "EntityTakeDamage", "EntityTakeDamage:BoringFPS:NotifyPlayerHit", function( target, dmginfo )
	if ( BoringFPS_CONFIG.GameInProgress and table.HasValue(BoringFPS_CONFIG.PlayersAlive, target) ) then
        if (IsValid(dmginfo:GetAttacker()) and dmginfo:GetAttacker():IsPlayer()) then
			BoringFPS.InsertLogs(target:Nick() .. " was hit by " .. dmginfo:GetAttacker():Nick() .. " and received\n" .. dmginfo:GetDamage() .. " damage.")
        else
            BoringFPS.InsertLogs(target:Nick() .. " received " .. dmginfo:GetDamage() .. " damage.")
		end
	end
end )