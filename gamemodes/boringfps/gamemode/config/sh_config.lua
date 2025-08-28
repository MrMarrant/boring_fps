-- Game settings, edit as you wish
BoringFPS_CONFIG.Settings = {}
BoringFPS_CONFIG.Settings.TimerPreGame = 5 -- Time in seconds before the game starts
BoringFPS_CONFIG.Settings.TimerPostGame = 5 -- Duration before game restart
BoringFPS_CONFIG.Settings.TimerDelayNextGame = 10 -- Duration before next game starts
BoringFPS_CONFIG.Settings.BaseHP = 100 -- Default health points for players
BoringFPS_CONFIG.Settings.MinPlayerRequired = 2 -- Minimum players required to start a game
BoringFPS_CONFIG.Settings.LimitTimeTurn = 10 -- Time limit for each player's turn
BoringFPS_CONFIG.Settings.TimerBetweenTurns = 1 -- Time limit between each player's turn
BoringFPS_CONFIG.Settings.DefaultMaxStep = 10 -- Default steps a player can do during his turn
BoringFPS_CONFIG.Settings.DefaultWalkSpeed = 250 -- Default walk speed for players
BoringFPS_CONFIG.Settings.DefaultRunSpeed = 320 -- Default run speed for players
BoringFPS_CONFIG.Settings.DurationAnnouncerTurn = 3 -- Define how much time announcer turn stay on screen
BoringFPS_CONFIG.Settings.MessageLifetimeChatBox = 8 -- Define how much time messages chatbox history are displayed.
BoringFPS_CONFIG.Settings.ListClass = {
    "pistol",
    "shootgun",
    "launcher",
    "crowbar"
}
BoringFPS_CONFIG.Settings.ClassWeapon = {
    ["pistol"] = "pistol_boring-gun",
    ["shootgun"] = "shootgun_boring-gun",
    ["launcher"] = "launcher_boring-gun",
    ["crowbar"] = "crowbar_boring-gun"
}
-- TODO : Déplacer la chat box si possible
BoringFPS_CONFIG.Settings.HideHUD = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudChat"] = true,
    ["CHudDeathNotice"] = true
}

-- Models
BoringFPS_CONFIG.Models = {}
BoringFPS_CONFIG.Models.Characters = {
    "models/alyx.mdl",
    "models/Eli.mdl",
    "models/gman_high.mdl",
    "models/Kleiner.mdl",
    "models/monk.mdl",
    "models/vortigaunt.mdl",
    "models/Humans/Group02/male_07.mdl"
}
BoringFPS_CONFIG.Models.Rocket = Model("models/props_c17/doll01.mdl")
BoringFPS_CONFIG.Models.SelectionClass = Model("models/props_borealis/bluebarrel001.mdl") --? Default model of the entity if none was set from hammer param

BoringFPS_CONFIG.Sounds = {}
BoringFPS_CONFIG.Sounds.TurnStart = Sound("boring_fps/sfx/turn/turn_start.mp3")
BoringFPS_CONFIG.Sounds.TurnEnd = Sound("boring_fps/sfx/turn/turn_end.mp3")
BoringFPS_CONFIG.Sounds.WinGame = Sound("boring_fps/sfx/turn/win_game.mp3")
BoringFPS_CONFIG.Sounds.OnUse = Sound("boring_fps/sfx/ui/on_use.mp3")
BoringFPS_CONFIG.Sounds.GameMusic = {
    "boring_fps/music/theme_boringfps.wav"
}


BoringFPS_CONFIG.Icons = {}
BoringFPS_CONFIG.Icons.StepIcon = Material("boringfps/icons/step_icon.png")
BoringFPS_CONFIG.Icons.ActionIcon = Material("boringfps/icons/action_icon.png")
BoringFPS_CONFIG.Icons.WeaponIcon = Material("boringfps/icons/weapon_icon.png")
BoringFPS_CONFIG.Icons.DashIcon = Material("boringfps/icons/dash_icon.png")
BoringFPS_CONFIG.Icons.HeartIcon = Material("boringfps/icons/heart_icon.png")
BoringFPS_CONFIG.Icons.HeartFillIcon = Material("boringfps/icons/heart_fill_icon.png")
BoringFPS_CONFIG.Icons.DisconnectedIcon = Material("boringfps/icons/skull_icon.png")
BoringFPS_CONFIG.Icons.InfiniteIcon = Material("boringfps/icons/infinite_icon.png")

-- NET VAR
BoringFPS_CONFIG.NetVar = {}
BoringFPS_CONFIG.NetVar.StartClientPlay = "BoringFPS_CONFIG.StartClientPlay"
BoringFPS_CONFIG.NetVar.StopClientTurn = "BoringFPS_CONFIG.StopClientTurn"
BoringFPS_CONFIG.NetVar.PlayClientSound = "BoringFPS_CONFIG.PlayClientSound"
BoringFPS_CONFIG.NetVar.StopPlayClientSound = "BoringFPS_CONFIG.StopPlayClientSound"
BoringFPS_CONFIG.NetVar.StartClientWait = "BoringFPS_CONFIG.StartClientWait"
BoringFPS_CONFIG.NetVar.StartClientHUDGame = "BoringFPS_CONFIG.StartClientHUDGame"
BoringFPS_CONFIG.NetVar.EndGame = "BoringFPS_CONFIG.StopClientHUDGame"
BoringFPS_CONFIG.NetVar.SetGlobalTable = "BoringFPS_CONFIG.SetGlobalTable"
BoringFPS_CONFIG.NetVar.InsertLogs = "BoringFPS_CONFIG.InsertLogs"

-- Base vars, i really don't recommend to edit this section
BoringFPS_CONFIG.Vars = {}
BoringFPS_CONFIG.Vars.PlayersInGame = {}
BoringFPS_CONFIG.Vars.GameLogs = {}