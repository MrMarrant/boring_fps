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
    hook.Remove( "Think", "GM:BoringFPS:Think:CanStartNewGame" )
    SetGlobalBool("IsStartTimerPreGame", false)
    SetGlobalString("CurrentGameState", "Game in progress...")
    BoringFPS.StopHUDPreGame()
    BoringFPS_CONFIG.GameInProgress = true
    BoringFPS.StartConditionEndGame(false)
    BoringFPS.SpawnPlayersOnGameMap()
    BoringFPS.DefineDirectionTurnPlay()
    timer.Simple(0.1, function() --? Weapon is null client side, so we are forced to wait until it's valid
    -- TODO : J'ai mis ça en place pour récupérer correctement les valeurs max (step, action, dash) des armes pour les HUD
    -- TODO : mais peut être il faudrait mieux set des variables cotés serveur (NW) et les récup coté client, ça éviterait d'utiliser ce timer.
        BoringFPS.SetTurnToWait(BoringFPS_CONFIG.Vars.PlayersInGame)
        BoringFPS.SetTurnToPlay(1)
        BoringFPS_CONFIG.Vars.CurrentMusic = table.Random(BoringFPS_CONFIG.Sounds.GameMusic)
        BoringFPS.PlaySound(BoringFPS_CONFIG.Vars.CurrentMusic, true)
        net.Start(BoringFPS_CONFIG.NetVar.StartClientHUDGame)
        net.Broadcast()
    end)
end

function BoringFPS.SpawnPlayersOnGameMap()
    local spawnPoints = BoringFPS.ShuffleTable(ents.FindByName("spawn_game"))
    local players = player.GetAll()
    local colorAvailable = BoringFPS_CONFIG.Settings.ColorPlayer
    local colorPlayer = {}
    BoringFPS.SetGlobalTable(players, "PlayersAlive")
    for index, ply in ipairs(players) do
        local weapon = ply:Give(BoringFPS_CONFIG.Settings.ClassWeapon[ply:GetNWString("ClassWeapon", BoringFPS_CONFIG.Settings.ListClass[1])])
        ply:SetNWEntity( "WeaponGame", weapon)
        colorPlayer[ply] = colorAvailable[index] or Color(0, 0, 0)
        weapon:SetClip1(weapon:GetMaxClip1()) --? We set here bc weapon doesnt load itself for some reasons
        local location = spawnPoints[index]
        if location then
            ply:SetPos(location:GetPos())
            ply:SetAngles(location:GetAngles())
        end
    end
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
    BoringFPS_CONFIG.LastIndexDirectionTurn = #directionTurn
    BoringFPS.SetGlobalTable(directionTurn, "PlayersInGame")
end

function BoringFPS.ResetParams()
    BoringFPS_CONFIG.CurrentPlayerTurn = nil
    BoringFPS_CONFIG.DirectionTurnPlayers = {}
    BoringFPS_CONFIG.LastIndexDirectionTurn = nil
    BoringFPS_CONFIG.GameInProgress = false
    BoringFPS.SetGlobalTable({}, "PlayersInGame")
    BoringFPS.SetGlobalTable({}, "PlayersAlive")
    BoringFPS.SetGlobalTable({}, "GameLogs")
    SetGlobalInt("CurrentIndexDirectionTurn", -1)
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
        if (ply:IsConnected()) then
            BoringFPS.EnterSpectatorMode(ply)
        end
        if (IsValid(attacker)) then
            BoringFPS.InsertLogs(ply:Nick() .. " was killed by " .. attacker:Nick() .. ".")
        else
            BoringFPS.InsertLogs(ply:Nick() .. " has died.")
        end
        ply:EmitSound("boring_fps/sfx/ded.mp3", 90, math.random(90, 110))
        net.Start(BoringFPS_CONFIG.NetVar.StopClientTurn)
        net.Send(ply)
    end
    if (table.Count(BoringFPS_CONFIG.Vars.PlayersAlive) <= 1) then
        BoringFPS.EndGame(false)
    end
end

function BoringFPS.OnPlayerHit(target, dmginfo)
    local attacker = dmginfo:GetAttacker()
    if (IsValid(attacker) and attacker:IsPlayer() and table.HasValue(BoringFPS_CONFIG.Vars.PlayersAlive, target) ) then
        BoringFPS.InsertLogs(target:Nick() .. " was hit by " .. attacker:Nick() .. " and received\n" .. math.Round( dmginfo:GetDamage() ) .. " damage.")
    else
        BoringFPS.InsertLogs(target:Nick() .. " received " .. math.Round( dmginfo:GetDamage() ) .. " damage.")
    end
end