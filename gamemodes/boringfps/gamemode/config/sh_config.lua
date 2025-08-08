-- Game settings, edit as you wish
BoringFPS_CONFIG.Settings = {}
BoringFPS_CONFIG.Settings.TimerWait = 5 -- Time in seconds before the next round starts
BoringFPS_CONFIG.Settings.BaseHP = 100 -- Default health points for players
BoringFPS_CONFIG.Settings.MinPlayerRequired = 2 -- Minimum players required to start a game
BoringFPS_CONFIG.Settings.LimitTimeTurn = 8 -- Time limit for each player's turn
BoringFPS_CONFIG.Settings.TimerBetweenTurns = 2 -- Time limit between each player's turn

-- NET VAR
BoringFPS_CONFIG.NetVar = {}
BoringFPS_CONFIG.NetVar.StartChronoTurn = "BoringFPS_CONFIG.StartChronoTurn"
BoringFPS_CONFIG.NetVar.StopChronoTurn = "BoringFPS_CONFIG.StopChronoTurn"

-- Base vars, i really don't recommend to edit this section
BoringFPS_CONFIG.Vars = {}
BoringFPS_CONFIG.Vars.PlayersVars = {}
BoringFPS_CONFIG.Vars.TypePlay = {
    ["play"] = true,
    ["wait"] = true
}
