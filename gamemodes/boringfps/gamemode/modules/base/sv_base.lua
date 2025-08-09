function BoringFPS.NewGame()
    -- Vérifier si le nombre de joueurs est suffisant
    BoringFPS.PrintToAllPlayers("Waiting for players to join...", HUD_PRINTCENTER)
    BoringFPS.ResetParams()
    hook.Add( "Think", "GM:BoringFPS:Think:CanStartNewGame", function()
        if BoringFPS.IsConditionMetNewGame() then
            BoringFPS.StartTimerPreGame()
        else
            timer.Remove("BoringFPS:PreGameTimer")
            timer.Remove("BoringFPS:CountdownTimer")
        end
    end )
end

function BoringFPS.StartTimerPreGame()
    -- Démarrer le timer avant le début du jeu
    if (not timer.Exists("BoringFPS:PreGameTimer")) then
        BoringFPS.PrintToAllPlayers("Game will start soon...", HUD_PRINTCENTER)
        BoringFPS.CountdownTimer(BoringFPS_CONFIG.Settings.TimerWait)
        timer.Create( "BoringFPS:PreGameTimer", BoringFPS_CONFIG.Settings.TimerWait, 1, function()
            BoringFPS.StartGame()
        end )
    end
end

function BoringFPS.StartGame()
    -- Démarrer le jeu
    hook.Remove( "Think", "GM:BoringFPS:Think:CanStartNewGame" )
    BoringFPS.PrintToAllPlayers("Game is starting!", HUD_PRINTCENTER)
    BoringFPS_CONFIG.GameInProgress = true

    -- Set les armes des joueurs
    -- lancer le tour du premier joueur
    -- Définir les autres joueurs dans l'état d'attente de leur tour
    BoringFPS.SpawnPlayersOnGameMap()
    BoringFPS.DefineDirectionTurnPlay()
    BoringFPS.SetTurnToWait(BoringFPS_CONFIG.PlayersInGame)
    BoringFPS.SetTurnToPlay(1)
end

function BoringFPS.SpawnPlayersOnGameMap()
    local spawnPoints = ents.FindByClass("info_player_rebel")
    local players = player.GetAll()
    BoringFPS_CONFIG.PlayersInGame = players
    -- Spawn les joueurs sur la map de jeu
    for index, ply in ipairs(players) do
        if spawnPoints[index] then
            ply:SetPos(spawnPoints[index]:GetPos())
            ply:SetAngles(spawnPoints[index]:GetAngles())
        end
    end
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
    table.CopyFromTo(BoringFPS_CONFIG.PlayersInGame, players)
    while (not table.IsEmpty(players)) do
        local index = math.random( #players )
        local ply = players[ index ]
        ply:SetNumberTurn(indexTurn)
        table.insert(directionTurn, indexTurn, ply)
        table.remove(players, index)
        indexTurn = indexTurn + 1
    end
    BoringFPS_CONFIG.DirectionTurnPlayers = directionTurn
    BoringFPS_CONFIG.PlayersAlive = directionTurn
end

function BoringFPS.ResetParams()
    BoringFPS_CONFIG.Vars.PlayersVars = {}
    BoringFPS_CONFIG.PlayersInGame = {}
    BoringFPS_CONFIG.PlayersAlive = {}
    BoringFPS_CONFIG.CurrentPlayerTurn = nil
    BoringFPS_CONFIG.DirectionTurnPlayers = {}
    BoringFPS_CONFIG.GameInProgress = false
    BoringFPS.StripPlayers(player.GetAll())
    hook.Remove("PlayerDeath:BoringFPS:ConditionEndGame")
    hook.Remove("PlayerDisconnected:BoringFPS:ConditionEndGame")
    timer.Remove("BoringFPS:TimerTurn")
    timer.Remove("BoringFPS:NextTurn")
    net.Start(BoringFPS_CONFIG.NetVar.StopClientTurn)
    net.Broadcast()
end

function BoringFPS.StartConditionEndGame()
    hook.Add("PlayerDeath", "PlayerDeath:BoringFPS:ConditionEndGame", BoringFPS.OnPlayerLeave)
    hook.Add("PlayerDisconnected", "PlayerDisconnected:BoringFPS:ConditionEndGame", BoringFPS.OnPlayerLeave)
end

function BoringFPS.OnPlayerLeave(ply)
    if (BoringFPS_CONFIG.DirectionTurnPlayers[ply:GetNumberTurn()]) then
        BoringFPS_CONFIG.DirectionTurnPlayers[ply:GetNumberTurn()] = nil
        table.RemoveByValue(BoringFPS_CONFIG.PlayersAlive, ply)
        if (ply:IsConnected()) then GAMEMODE:PlayerSpawnAsSpectator( ply ) end
    end
    if (#BoringFPS_CONFIG.DirectionTurnPlayers <= 1) then
        BoringFPS.EndGame()
    end
end