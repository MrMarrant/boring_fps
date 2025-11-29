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
    BoringFPS.InsertLogs(BoringFPS.GetTranslation("turn_to_play", ply:GetName()))
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
        BoringFPS.InsertLogs(BoringFPS.GetTranslation("turn_ended", ply:GetName()))
        BoringFPS.SetTurnToWait({ply})
        local players = table.Copy(BoringFPS_CONFIG.Vars.PlayersAlive)
        table.RemoveByValue(players, ply)
        BoringFPS.ReadSound(BoringFPS_CONFIG.Sounds.NotifTurnEnd, game.GetWorld(), 0, players)
    else
        BoringFPS.InsertLogs(BoringFPS.GetTranslation("turn_end"))
        BoringFPS.ReadSound(BoringFPS_CONFIG.Sounds.NotifTurnEnd, game.GetWorld(), 0)
    end
    timer.Create("BoringFPS:NextTurn", BoringFPS_CONFIG.Settings.TimerBetweenTurns, 1, function()
        BoringFPS.SetTurnToPlay(BoringFPS.GetNextPlayerTurn())
    end)
end

function BoringFPS.GetNextPlayerTurn()
    local nextIndex = GetGlobalInt("CurrentIndexDirectionTurn", 0)
    local sizeTable = BoringFPS_CONFIG.Vars.NumberOfPlayers

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
    local winner = reset and nil or BoringFPS_CONFIG.Vars.PlayersAlive[1]
    if (not reset) then
        hook.Call("OnNewDataPlayer", nil, winner, "win")
    end
    local name = IsValid(winner) and winner:GetName() or "MrMarrant"
    local congratMsg = reset and "DRAW" or name .. "'s has won!"

    BoringFPS_CONFIG.Vars.CurrentRound = BoringFPS_CONFIG.Vars.CurrentRound + 1
    BoringFPS.ReadSound(BoringFPS_CONFIG.Sounds.WinGame, game.GetWorld(), 0 )
    BoringFPS.SetExperience(winner)
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
        if (BoringFPS_CONFIG.Vars.CurrentRound >= BoringFPS_CONFIG.Settings.RoundsBeforeChangeMap) then
            BoringFPS.ChangeToNextMap()
        else
            BoringFPS.NewGame()
        end
    end)
end

function BoringFPS.CheckEndGameEvent()
    if (GetGlobalBool("EndGameEnabled", false)) then return end

    local playersAlive = #BoringFPS_CONFIG.Vars.PlayersAlive
    local playersInGame = BoringFPS_CONFIG.Vars.NumberOfPlayers
    local currentTurn = GetGlobalInt("GlobalTurn", 0)

    if (playersInGame and (playersAlive <= math.ceil(playersInGame / 2)) and currentTurn >= BoringFPS_CONFIG.Settings.GlobalTurnEndGame) then
        BoringFPS.StartEndGameEvent()
    end
end

function BoringFPS.SetExperience(winner)
    local players = BoringFPS_CONFIG.Vars.PlayersInGame
    local expGain = BoringFPS_CONFIG.Settings.ExperienceGainByGame
    local differenceExp = BoringFPS_CONFIG.Settings.DifferenceExperienceBetweenLevels
    for key, ply in ipairs(players) do
        if (IsValid(ply) and istable(ply.BFPS_DataPlayer)) then
            local ammountExp = ply == winner and expGain + BoringFPS_CONFIG.Settings.ExperienceBonusWinner or expGain
            ply:AddExperience(ammountExp)
        end
    end
end

function BoringFPS.StartEndGameEvent()
    SetGlobalBool("EndGameEnabled", true)
    BoringFPS.InsertLogs(BoringFPS.GetTranslation("start_end_game_event"))
    if (BoringFPS_CONFIG.Vars.CurrentMusic) then
        BoringFPS_CONFIG.Vars.CurrentMusic:FadeOut(4)
    end
    BoringFPS_CONFIG.Vars.CurrentMusic = BoringFPS.ReadSound(BoringFPS_CONFIG.Sounds.EndEventMusic, game.GetWorld(), 0, nil, 10)
    hook.Add("NewGlobalTurn", "BoringFPS:NewGlobalTurn:HitPlayers", function ()
        local playersAlive = BoringFPS_CONFIG.Vars.PlayersAlive
        local defaultLimitTimer = BoringFPS_CONFIG.Settings.LimitTimeTurn
        local damageTurn = BoringFPS_CONFIG.Settings.DamageEndGame
        for key, survivor in ipairs(playersAlive) do
            BoringFPS.InsertLogs(BoringFPS.GetTranslation("endgame_hit", survivor:Nick(), math.Round(damageTurn)))
            survivor:TakeDamage(damageTurn, game.GetWorld(), game.GetWorld())
        end
        BoringFPS.RevealAura(BoringFPS_CONFIG.Settings.DurationRevealEndGame, playersAlive, Color(153, 0, 0))
        SetGlobalInt("CurrentLimitTimer", math.Clamp(GetGlobalInt("CurrentLimitTimer", defaultLimitTimer) - 1, defaultLimitTimer / 2, defaultLimitTimer))
    end)
end

function BoringFPS.SlomwMotion(duration, timeScale)
    timeScale = timeScale or 0.1
    game.SetTimeScale(timeScale)
    timer.Create("BoringFPS:ResetTimeScale", duration * timeScale, 1, function()
        game.SetTimeScale(1)
    end)
end

function BoringFPS.ChangeToNextMap()
    local maps = file.Find("maps/bfps*.bsp", "GAME")
    local cleaned = {}

    for _, map in ipairs(maps) do
        cleaned[#cleaned+1] = string.gsub(map, "%.bsp$", "")
    end
    maps = cleaned

    if (#maps <= 1) then ErrorNoHalt("Your server has only one map available for change!")
        BoringFPS.NewGame()
    else
        PrintTable(maps)
        net.Start(BoringFPS_CONFIG.NetVar.ChangeMap)
        net.WriteTable(maps)
        net.Broadcast()
        BoringFPS.LoadNextMap()
    end
end

function BoringFPS.LoadNextMap()
    timer.Create("BoringFPS:LoadNextMap", 10, 1, function()
        local winningMaps = {}
        local winningMap
        local maxVotes = 0
        local voteMap = BoringFPS_CONFIG.Vars.VoteMap
        for map, votes in pairs(voteMap) do
            if (votes > maxVotes) then
                maxVotes = votes
                winningMaps = {map}
            elseif (votes == maxVotes) then
                table.insert(winningMaps, map)
            end
        end
        if (#winningMaps == 0 or (#winningMaps == 1 and winningMaps[1] == game.GetMap())) then
            PrintMessage(HUD_PRINTCENTER, "[BoringFPS] No votes or same map selected, extended current map.")
            BoringFPS.NewGame()
        else
            if (#winningMaps > 1) then
                winningMap = winningMaps[math.random(#winningMaps)]
                if (#winningMaps == 0 or (winningMaps == 1 and winningMaps[1] == game.GetMap())) then
                    PrintMessage(HUD_PRINTCENTER, "[BoringFPS] Same map selected, extended current map.")
                    BoringFPS.NewGame()
                    return
                end
            else
                winningMap = winningMaps[1]
            end
            PrintMessage(HUD_PRINTCENTER, "[BoringFPS] Next map will be: " .. winningMap .. " with " .. maxVotes .. " votes!")
            timer.Create("BoringFPS:DelayChangeLevel", 5, 1, function()
                RunConsoleCommand("changelevel", winningMap)
            end)
        end
    end)
    BoringFPS_CONFIG.Vars.VoteMap = {}
    BoringFPS_CONFIG.Vars.PlayersVoteMap = {}
end

function BoringFPS.ReceiveVoteMap(selectedMap, ply)
    local previousVote = BoringFPS_CONFIG.Vars.PlayersVoteMap[ply]
    if (previousVote == selectedMap) then return end

    if (previousVote) then
        BoringFPS_CONFIG.Vars.VoteMap[previousVote] = BoringFPS_CONFIG.Vars.VoteMap[previousVote] - 1
    end
    BoringFPS_CONFIG.Vars.PlayersVoteMap[ply] = selectedMap
    if (selectedMap != "") then
        BoringFPS_CONFIG.Vars.VoteMap[selectedMap] = BoringFPS_CONFIG.Vars.VoteMap[selectedMap] and BoringFPS_CONFIG.Vars.VoteMap[selectedMap] + 1 or 1
    end
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

net.Receive(BoringFPS_CONFIG.NetVar.VoteMap, function(_, ply)
    local selectedMap = net.ReadString()
    BoringFPS.ReceiveVoteMap(selectedMap, ply)
end)