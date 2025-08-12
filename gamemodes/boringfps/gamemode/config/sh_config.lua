-- Game settings, edit as you wish
BoringFPS_CONFIG.Settings = {}
BoringFPS_CONFIG.Settings.TimerPreGame = 5 -- Time in seconds before the game starts
BoringFPS_CONFIG.Settings.TimerPostGame = 5 -- Duration before game restart
BoringFPS_CONFIG.Settings.TimerDelayNextGame = 10 -- Duration before next game starts
BoringFPS_CONFIG.Settings.BaseHP = 100 -- Default health points for players
BoringFPS_CONFIG.Settings.MinPlayerRequired = 2 -- Minimum players required to start a game
BoringFPS_CONFIG.Settings.LimitTimeTurn = 5 -- Time limit for each player's turn
BoringFPS_CONFIG.Settings.TimerBetweenTurns = 1 -- Time limit between each player's turn
BoringFPS_CONFIG.Settings.DefaultMaxStep = 10 -- Default steps a player can do during his turn
BoringFPS_CONFIG.Settings.DefaultWalkSpeed = 250 -- Default walk speed for players
BoringFPS_CONFIG.Settings.DefaultRunSpeed = 320 -- Default run speed for players
BoringFPS_CONFIG.Settings.ListWeapons = {
    "pistol_boring-gun",
    "shootgun_boring-gun",
    "launcher_boring-gun",
    "crowbar_boring-gun"
}

-- Models
BoringFPS_CONFIG.Models = {}
BoringFPS_CONFIG.Models.Rocket = Model("models/props_c17/doll01.mdl")

-- NET VAR
BoringFPS_CONFIG.NetVar = {}
BoringFPS_CONFIG.NetVar.StartClientTurn = "BoringFPS_CONFIG.StartClientTurn"
BoringFPS_CONFIG.NetVar.StopClientTurn = "BoringFPS_CONFIG.StopClientTurn"
BoringFPS_CONFIG.NetVar.PlayClientSound = "BoringFPS_CONFIG.PlayClientSound"
BoringFPS_CONFIG.NetVar.StopPlayClientSound = "BoringFPS_CONFIG.StopPlayClientSound"

-- Base vars, i really don't recommend to edit this section
BoringFPS_CONFIG.Vars = {}
BoringFPS_CONFIG.Vars.PlayersVars = {}