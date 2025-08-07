function BoringFPS.NewGame()
    -- Vérifier si le nombre de joueurs est suffisant
    BoringFPS.PrintToAllPlayers("Waiting for players to join...", HUD_PRINTCENTER)
    hook.Add( "Think", "GM:BoringFPS:Think:CanStartNewGame", function()
        if IsConditionMetNewGame() then
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
        BoringFPS.CountdownTimer(BoringFPS_CONFIG.TimerWait)
        timer.Create( "BoringFPS:PreGameTimer", BoringFPS_CONFIG.TimerWait, 1, function()
            BoringFPS.StartGame()
        end )
    end
end

function BoringFPS.StartGame()
    -- Démarrer le jeu
    hook.Remove( "Think", "GM:BoringFPS:Think:CanStartNewGame" )
    BoringFPS.PrintToAllPlayers("Game is starting!", HUD_PRINTCENTER)
end

function IsConditionMetNewGame()
    -- Vérifier si le nombre de joueurs est suffisant
    if #player.GetAll() >= BoringFPS_CONFIG.minPlayerRequired then
        return true
    end

    return false
end