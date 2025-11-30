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
    local players = BoringFPS_CONFIG.Vars.PlayersAlive
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

function BoringFPS.GetSpawnPoints()
    local spawnPoints = ents.FindByName("spawn_game")
    if (#spawnPoints == 0) then
        spawnPoints = ents.FindByClass("info_player_start")
    end
    spawnPoints = BoringFPS.ShuffleTable(spawnPoints)
    return spawnPoints
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

function BoringFPS.KnockBack(attacker, target, strength)
    strength = strength or 300
    local forceDir = (target:GetPos() - attacker:GetPos()):GetNormalized()
    local velocityApplied = forceDir * strength + target:GetVelocity()

    target:SetVelocity(velocityApplied)
    BoringFPS.AddKnockBackHook(target, velocityApplied, attacker)
end

function BoringFPS.AddKnockBackHook(target, velocityApplied, attacker)
    local minVelocity = BoringFPS_CONFIG.Settings.MinVelocityKnockBackDamage or 500
    if (velocityApplied:Length() < minVelocity) then return end

    local velocityMaxReached = 0
    local minVelocityToReach = velocityApplied:Length() * 0.8 --? Velocity applied will never be reached, so we define a minimum velocity to reach to apply damage
    hook.Add( "Think", "BoringFPS:KnockBackThink-" .. target:EntIndex(), function()
        if (IsValid(target)) then
            local vel = Vector( target:GetVelocity().x, target:GetVelocity().y, 0 )
            local tr = BoringFPS.CollideEvent(target, vel)
            local velLength = vel:Length()

            velocityMaxReached = velLength > velocityMaxReached and velLength or velocityMaxReached
            if (tr.Hit) then
                velLength = velocityMaxReached < minVelocityToReach and minVelocityToReach or velLength
                BoringFPS.AppliedKnockBackDamage(target, velLength, attacker)
            end
            if (velLength <= 10) then
                hook.Remove("Think", "BoringFPS:KnockBackThink-" .. target:EntIndex())
            end
        end
    end )
end

function BoringFPS.AppliedKnockBackDamage(target, velLength, attacker)
    target:SetVelocity( Vector(0, 0, 0) )
    local maxVelocity = BoringFPS_CONFIG.Settings.MaxVelocityKnockBackDamage or 1000
    local minVelocity = BoringFPS_CONFIG.Settings.MinVelocityKnockBackDamage or 500
    local t = (math.Clamp(velLength, minVelocity, maxVelocity) - minVelocity) / (maxVelocity - minVelocity)
    local dmg = Lerp(t, BoringFPS_CONFIG.Settings.MinDamageKnockBack, BoringFPS_CONFIG.Settings.MaxDamageKnockBack)

    hook.Remove("Think", "BoringFPS:KnockBackThink-" .. target:EntIndex())
    timer.Simple(0.2, function() --? Avoid instant kill without force applied
        if (not IsValid(target)) then return end
        target:TakeDamage(dmg, attacker, attacker)
    end)
end

function BoringFPS.CollideEvent(target, velocity)
    local div = velocity * 0.1

    local tr = util.TraceHull( {
        start = target:GetPos() + Vector( 0, 0, 30 ),
        endpos = target:GetPos() + Vector( 0, 0, 30 ) + div,
        mins = Vector( -20, -20, -20 ),
        maxs = Vector( 20, 20, 20 ),
        filter = function(ent) if ( ent:IsPlayer() ) then return false end return true end,
    })

    return tr
end

function BoringFPS.SetVisibilityRender(ent, isVisible)
    local renderMode = isVisible and RENDERMODE_TRANSCOLOR or RENDERMODE_TRANSALPHA
    local renderColor = isVisible and Color(255, 255, 255, 255) or Color(0, 0, 0, 0)

    ent:SetRenderMode(renderMode)
    ent:SetColor(renderColor)
end

function BoringFPS.RevealAura(duration, tableEnt, colorAura, ply)
    colorAura = colorAura or Color( 255, 0, 0 )
    net.Start(BoringFPS_CONFIG.NetVar.RevealAura)
    net.WriteFloat(duration)
    net.WriteTable(tableEnt)
    net.WriteColor(colorAura)

    if (IsValid(ply)) then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

function BoringFPS.IsLocationFree(pos, ply)
    -- Default hull
    local hullMin = Vector(-16, -16, 0)
    local hullMax = Vector(16, 16, 72)

    if IsValid(ply) then
        hullMin, hullMax = ply:GetHull()
    end

    local tr = util.TraceHull({
        start = pos,
        endpos = pos + Vector(0, 0, hullMax.z),
        mins = hullMin,
        maxs = hullMax,
        ignoreworld = true,
        filter = function(ent)
            if not IsValid(ent) then return false end
            if (ent == ply) then return false end
            if ent:GetMoveType() == MOVETYPE_NOCLIP then return false end
            return true
        end
    })

    return not tr.Hit
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