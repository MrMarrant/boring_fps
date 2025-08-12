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

hook.Add( "PlayerDeathThink", "PlayerDeathThink:BoringFPS:SpectatorNext", function( ply )
    if ply:GetObserverMode() == OBS_MODE_CHASE and ply:KeyPressed( IN_ATTACK ) then
        local nextTarget = BoringFPS.FindNextAlivePlayer(ply, ply:GetObserverTarget())
        if IsValid(nextTarget) then
            ply:SpectateEntity(nextTarget)
            return false
        end
    end
end )