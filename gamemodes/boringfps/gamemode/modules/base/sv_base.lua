function BoringFPS.NewGame()
    SetGlobalString("CurrentGameState", "Starting a new game in " .. BoringFPS_CONFIG.Settings.TimerDelayNextGame .. " seconds...")
    BoringFPS.DisplayHUDPreGame()
    timer.Create("BoringFPS:TimerDelayNextGame", BoringFPS_CONFIG.Settings.TimerDelayNextGame, 1, function()
        SetGlobalString("CurrentGameState", "Waiting for players to join...")
        BoringFPS.ResetParams()
        hook.Add( "Think", "GM:BoringFPS:Think:CanStartNewGame", function()
            -- Vérifie si les conditions de partie sont remplies
            if BoringFPS.IsConditionMetNewGame() then
                BoringFPS.StartTimerPreGame()
            else
                SetGlobalBool("IsStartTimerPreGame", false)
                timer.Remove("BoringFPS:PreGameTimer")
                timer.Remove("BoringFPS:CountdownTimer")
            end
        end )
    end)
end

function BoringFPS.StartTimerPreGame()
    -- Démarrer le timer avant le début du jeu
    if (not timer.Exists("BoringFPS:PreGameTimer")) then
        SetGlobalString("CurrentGameState", "Game will start soon...")
        SetGlobalBool("IsStartTimerPreGame", true)
        timer.Create( "BoringFPS:PreGameTimer", BoringFPS_CONFIG.Settings.TimerPreGame, 1, function()
            BoringFPS.StartGame()
        end )
    end
end

function BoringFPS.StartGame()
    -- Démarrer le jeu
    hook.Remove("Think", "GM:BoringFPS:Think:CanStartNewGame")
    SetGlobalBool("IsStartTimerPreGame", false)
    SetGlobalBool("GameInProgress", true)
    SetGlobalString("CurrentGameState", "Game in progress...")
    SetGlobalInt("GlobalTurn", 1)
    SetGlobalInt("CurrentLimitTimer", BoringFPS_CONFIG.Settings.LimitTimeTurn)
    BoringFPS.StopHUDPreGame()
    BoringFPS.SpawnPlayersOnGameMap()
    BoringFPS.DefineDirectionTurnPlay()
    BoringFPS.StartConditionEndGame()
    BoringFPS.SetTurnToWait(BoringFPS_CONFIG.Vars.PlayersInGame, true)
    BoringFPS.SetTurnToPlay(1)
    BoringFPS_CONFIG.Vars.CurrentMusic = BoringFPS.ReadSound(table.Random(BoringFPS_CONFIG.Sounds.GameMusic), game.GetWorld(), 0)
    net.Start(BoringFPS_CONFIG.NetVar.StartClientHUDGame)
    net.Broadcast()
end

function BoringFPS.SpawnPlayersOnGameMap()
    local spawnPoints = BoringFPS.ShuffleTable(ents.FindByName("spawn_game"))
    local playersGet = table.ShuffleSequential( player.GetAll() )
    local colorAvailable = BoringFPS_CONFIG.Settings.ColorPlayer
    local colorPlayer = {}

    for index, ply in ipairs(playersGet) do
        local location = spawnPoints[index]
        if location then
            local class = ply:GetNWString("ClassWeapon", BoringFPS_CONFIG.Settings.ListClass[1])
            local weapon = ply:Give(BoringFPS_CONFIG.Settings.Weapons[class].ClassName)
            ply:SetPos(location:GetPos())
            ply:SetAngles(location:GetAngles())
            ply:SetNWEntity( "WeaponGame", weapon)
            weapon:SetClip1(weapon:GetMaxClip1()) --? We set here bc weapon doesnt load itself for some reasons
            colorPlayer[ply] = colorAvailable[index] or Color(0, 0, 0)
            ply:SetDataStats(class, "count_select", 1)
        else
            ply:ChatPrint(BoringFPS.GetTranslation("not_enough_spawns"))
            ply:KillSilent()
            BoringFPS.EnterSpectatorMode(ply)
        end
    end
    local players = table.Count(playersGet) > #spawnPoints and BoringFPS.TableShrink(playersGet, table.Count(playersGet) - #spawnPoints) or playersGet
    BoringFPS.SetGlobalTable(players, "PlayersAlive")
    BoringFPS.SetGlobalTable(colorPlayer, "ColorBox")
end

function BoringFPS.IsConditionMetNewGame()
    -- Vérifier si le nombre de joueurs est suffisant
    if #player.GetAll() >= BoringFPS_CONFIG.Settings.MinPlayerRequired then
        return true
    end

    return false
end

function BoringFPS.DefineDirectionTurnPlay()
    local players = {}
    local directionTurn = {}
    local indexTurn = 1
    table.CopyFromTo(BoringFPS_CONFIG.Vars.PlayersAlive, players)
    while (not table.IsEmpty(players)) do
        local index = math.random( #players )
        local ply = players[ index ]
        ply:SetNWInt("NumberTurn", indexTurn)
        table.insert(directionTurn, indexTurn, ply)
        table.remove(players, index)
        indexTurn = indexTurn + 1
    end
    BoringFPS_CONFIG.DirectionTurnPlayers = directionTurn
    BoringFPS_CONFIG.Vars.NumberOfPlayers = #directionTurn
    BoringFPS.SetGlobalTable(table.Copy(directionTurn), "PlayersInGame")
end

function BoringFPS.ResetParams()
    BoringFPS_CONFIG.CurrentPlayerTurn = nil
    BoringFPS_CONFIG.DirectionTurnPlayers = {}
    BoringFPS_CONFIG.Vars.NumberOfPlayers = nil
    BoringFPS.SetGlobalTable({}, "PlayersInGame")
    BoringFPS.SetGlobalTable({}, "PlayersAlive")
    BoringFPS.SetGlobalTable({}, "GameLogs")
    SetGlobalBool("GameInProgress", false)
    SetGlobalBool("EndGameEnabled", false)
    SetGlobalInt("GlobalTurn", 0)
    SetGlobalInt("CurrentIndexDirectionTurn", -1)
    hook.Remove("NewGlobalTurn", "BoringFPS:NewGlobalTurn:HitPlayers")
    hook.Remove("PlayerDeath", "PlayerDeath:BoringFPS:ConditionEndGame")
    hook.Remove("PlayerDisconnected", "PlayerDisconnected:BoringFPS:ConditionEndGame")
    hook.Remove("EntityTakeDamage", "EntityTakeDamage:BoringFPS:NotifyPlayerHit")
    timer.Remove("BoringFPS:TimerTurn")
    timer.Remove("BoringFPS:NextTurn")
    net.Start(BoringFPS_CONFIG.NetVar.StopClientTurn)
    net.Broadcast()
end

function BoringFPS.StartConditionEndGame()
    hook.Add("PlayerDeath", "PlayerDeath:BoringFPS:ConditionEndGame", BoringFPS.OnPlayerLeave)
    hook.Add("PlayerDisconnected", "PlayerDisconnected:BoringFPS:ConditionEndGame", BoringFPS.OnPlayerLeave)
    hook.Add( "EntityTakeDamage", "EntityTakeDamage:BoringFPS:NotifyPlayerHit", BoringFPS.OnPlayerHit)
end

function BoringFPS.OnPlayerLeave(ply, inflictor, attacker)
    if (BoringFPS_CONFIG.DirectionTurnPlayers[ply:GetNWInt("NumberTurn")]) then
        BoringFPS_CONFIG.DirectionTurnPlayers[ply:GetNWInt("NumberTurn")] = nil
        table.remove(BoringFPS_CONFIG.Vars.PlayersAlive, table.KeyFromValue(BoringFPS_CONFIG.Vars.PlayersAlive, ply))
        BoringFPS.SetGlobalTable(BoringFPS_CONFIG.Vars.PlayersAlive, "PlayersAlive")
        if (ply:IsConnected()) then
            BoringFPS.EnterSpectatorMode(ply)
        end
        if (IsValid(attacker)) then
            if (attacker:IsPlayer()) then
                BoringFPS.InsertLogs(BoringFPS.GetTranslation("player_killed", ply:Nick(), attacker:Nick()))
            else
                BoringFPS.InsertLogs(BoringFPS.GetTranslation("player_died", ply:Nick()))
            end
            BoringFPS.SlomwMotion(1, 0.1)
        end
        if (ply == BoringFPS_CONFIG.CurrentPlayerTurn) then
            BoringFPS.EndTurn()
        end
        BoringFPS.ReadSound( BoringFPS_CONFIG.Sounds.DeathSound, ply, 120 )
        net.Start(BoringFPS_CONFIG.NetVar.StopClientTurn)
        net.Send(ply)

        BoringFPS.CheckEndGameEvent()
    end
    if (table.Count(BoringFPS_CONFIG.Vars.PlayersAlive) <= 1) then
        BoringFPS.GameFinish(false)
    end
end

function BoringFPS.OnPlayerHit(target, dmginfo)
    local attacker = dmginfo:GetAttacker()
    if (IsValid(attacker) and attacker:IsPlayer() and table.HasValue(BoringFPS_CONFIG.Vars.PlayersAlive, target) ) then
        BoringFPS.InsertLogs(BoringFPS.GetTranslation("on_hit", target:Nick(), attacker:Nick(), math.Round( dmginfo:GetDamage())))
    end
end

function GM:ShowHelp( ply )
    net.Start(BoringFPS_CONFIG.NetVar.OpenHelpMenu)
    net.Send(ply)
end