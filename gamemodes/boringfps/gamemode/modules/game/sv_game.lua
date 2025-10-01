function BoringFPS.DisplayHUDPreGame(ply)
    net.Start(BoringFPS_CONFIG.NetVar.StartClientPreGame)
    if (IsValid(ply)) then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

function BoringFPS.StopHUDPreGame()
    net.Start(BoringFPS_CONFIG.NetVar.StopClientPreGame)
    net.Broadcast()
end

function BoringFPS.SetTurnToWait(players, firstTurn)
    for key, value in ipairs(players) do
        value:SetState("wait")
        net.Start(BoringFPS_CONFIG.NetVar.StartClientWait)
        net.WriteBool(firstTurn or false)
        net.Send(value)
    end
end

function BoringFPS.SetTurnToPlay(index)
    local ply = BoringFPS_CONFIG.DirectionTurnPlayers[index]
    if (not IsValid(ply)) then return end

    hook.Call("PlayerTurnStart", nil, ply)
    SetGlobalInt("CurrentIndexDirectionTurn", index)
    BoringFPS_CONFIG.CurrentPlayerTurn = ply
    BoringFPS.InsertLogs(ply:GetName() .. "'s turn to play!")
    ply:SetState("play")
    BoringFPS.StartTimerTurn()
end

function BoringFPS.StartTimerTurn()
    if (not timer.Exists("BoringFPS:TimerTurn")) then
        timer.Create("BoringFPS:TimerTurn", GetGlobalInt("CurrentLimitTimer", BoringFPS_CONFIG.Settings.LimitTimeTurn), 1, function()
            BoringFPS.EndTurn()
        end)
    end
end

function BoringFPS.EndTurn()
    timer.Remove("BoringFPS:TimerTurn")
    local ply = BoringFPS_CONFIG.CurrentPlayerTurn
    hook.Call("PlayerTurnEnd", nil, ply)
    hook.Call("OnNewDataPlayer", nil, ply, "turn_done")
    if (IsValid(ply)) then
        BoringFPS.InsertLogs(ply:GetName() .. "'s turn has ended!")
        BoringFPS.SetTurnToWait({ply})
        local players = table.Copy(BoringFPS_CONFIG.Vars.PlayersAlive)
        table.RemoveByValue(players, ply)
        BoringFPS.ReadSound(BoringFPS_CONFIG.Sounds.NotifTurnEnd, game.GetWorld(), 0, players)
    else
        BoringFPS.InsertLogs("Turn has ended!")
        BoringFPS.ReadSound(BoringFPS_CONFIG.Sounds.NotifTurnEnd, game.GetWorld(), 0)
    end
    timer.Create("BoringFPS:NextTurn", BoringFPS_CONFIG.Settings.TimerBetweenTurns, 1, function()
        BoringFPS.SetTurnToPlay(BoringFPS.GetNextPlayerTurn())
    end)
end

function BoringFPS.GetNextPlayerTurn()
    local nextIndex = GetGlobalInt("CurrentIndexDirectionTurn", 0)
    local sizeTable = BoringFPS_CONFIG.LastIndexDirectionTurn

    for i = 1, sizeTable do
        nextIndex = nextIndex + 1
        if nextIndex > sizeTable then
            nextIndex = 1
            BoringFPS.NewGlobalTurn()
        end
        if (BoringFPS_CONFIG.DirectionTurnPlayers[nextIndex]) then
            return nextIndex -- Return the new index and exit this loop
        end
    end
    return -1
end

function BoringFPS.NewGlobalTurn()
    local currentGlobalTurn = GetGlobalInt("GlobalTurn", 1) + 1
    SetGlobalInt("GlobalTurn", currentGlobalTurn)
    hook.Call("NewGlobalTurn")
    BoringFPS.CheckEndGameEvent()
end

function BoringFPS.GameFinish(reset)
    local winner = BoringFPS_CONFIG.Vars.PlayersAlive[1]
    if (not reset) then
        hook.Call("OnNewDataPlayer", nil, winner, "win")
    end
    local name = IsValid(winner) and winner:GetName() or "MrMarrant"
    local congratMsg = reset and "DRAW" or name .. "'s has won!"

    BoringFPS.InsertLogs(congratMsg)
    BoringFPS.ReadSound(BoringFPS_CONFIG.Sounds.WinGame, game.GetWorld(), 0 )
    for k, survivor in ipairs(BoringFPS_CONFIG.Vars.PlayersAlive) do
        survivor:SetState("free")
    end
    net.Start(BoringFPS_CONFIG.NetVar.EndGame)
    net.WriteString(congratMsg)
    net.Broadcast()
    BoringFPS.ResetParams()
    -- TODO : Save les données des joueurs ici aussi ?
    timer.Create("BoringFPS:TimerPostGame", BoringFPS_CONFIG.Settings.TimerPostGame, 1, function ()
        for key, value in ipairs(player.GetAll()) do
            value:UnSpectate()
            value:Spawn()
            value:SetState("free")
            value:SetNWInt("NumberTurn", -1)
            value:SetNWInt("StepLeft", -1)
            value:SetNWEntity( "WeaponGame", nil )
            value:SetNWInt("Dash", -1)
            value:StripWeapons()
        end
        if (BoringFPS_CONFIG.Vars.CurrentMusic) then
            BoringFPS_CONFIG.Vars.CurrentMusic:Stop()
        end
        BoringFPS.NewGame()
    end)
end

function BoringFPS.CheckEndGameEvent()
    if (GetGlobalBool("EndGameEnabled", false)) then return end

    local playersAlive = #BoringFPS_CONFIG.Vars.PlayersAlive
    local playersInGame = BoringFPS_CONFIG.Vars.NumberOfPlayers
    local currentTurn = GetGlobalInt("GlobalTurn", 0)

    if ((playersAlive <= math.ceil(playersInGame / 2)) and currentTurn >= BoringFPS_CONFIG.Settings.GlobalTurnEndGame) then
        BoringFPS.StartEndGameEvent()
    end
end

function BoringFPS.StartEndGameEvent()
    SetGlobalBool("EndGameEnabled", true)
    BoringFPS.InsertLogs("Starting end game event!")
    if (BoringFPS_CONFIG.Vars.CurrentMusic) then
        BoringFPS_CONFIG.Vars.CurrentMusic:FadeOut(4)
    end
    BoringFPS_CONFIG.Vars.CurrentMusic = BoringFPS.ReadSound(BoringFPS_CONFIG.Sounds.EndEventMusic, game.GetWorld(), 0, nil, 10)
    hook.Add("NewGlobalTurn", "BoringFPS:NewGlobalTurn:HitPlayers", function ()
        local playersAlive = BoringFPS_CONFIG.Vars.PlayersAlive
        local defaultLimitTimer = BoringFPS_CONFIG.Settings.LimitTimeTurn
        local damageTurn = BoringFPS_CONFIG.Settings.DamageEndGame
        for key, survivor in ipairs(playersAlive) do
            BoringFPS.InsertLogs(survivor:Nick() .. " received " .. math.Round(damageTurn) .. " damage\n from end game event!")
            survivor:TakeDamage(damageTurn, game.GetWorld(), game.GetWorld())
        end
        BoringFPS.RevealAura(BoringFPS_CONFIG.Settings.DurationRevealEndGame, playersAlive, Color(153, 0, 0))
        SetGlobalInt("CurrentLimitTimer", math.Clamp(GetGlobalInt("CurrentLimitTimer", defaultLimitTimer) - 1, defaultLimitTimer / 2, defaultLimitTimer))
    end)
end

hook.Add( "EntityTakeDamage", "BoringFPS:EntityTakeDamage:ShootGunKnockBack", function( target, dmginfo )
    if (IsValid(dmginfo:GetInflictor()) and dmginfo:GetInflictor():GetClass() == "shootgun_boring-gun") then
        local damage = dmginfo:GetDamage()
        local force = Lerp(math.Clamp(damage, 0, 80) / 80, 0 , 300)

        BoringFPS.KnockBack(dmginfo:GetInflictor(), target, force)
    end
end)

hook.Add("PlayerSelectSpawn", "BoringFPS:PlayerSelectSpawn:SelectSpawn", function(ply)
	local spawns = ents.FindByClass("info_player_start")
    local spawnSelect = spawns[ math.random( #spawns ) ]
    for key, value in ipairs(spawns) do
        local posInfo = value:GetPos()
        if (BoringFPS.IsLocationFree(posInfo, ply)) then
            return value
        end
    end

	return spawnSelect
end)