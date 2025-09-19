-- Icons Material
BoringFPS_CONFIG.Icons = {}
BoringFPS_CONFIG.Icons.StepIcon = Material("boringfps/icons/step_icon.png")
BoringFPS_CONFIG.Icons.ActionIcon = Material("boringfps/icons/action_icon.png")
BoringFPS_CONFIG.Icons.WeaponIcon = Material("boringfps/icons/weapon_icon.png")
BoringFPS_CONFIG.Icons.DashIcon = Material("boringfps/icons/dash_icon.png")
BoringFPS_CONFIG.Icons.HeartIcon = Material("boringfps/icons/heart_icon.png")
BoringFPS_CONFIG.Icons.HeartFillIcon = Material("boringfps/icons/heart_fill_icon.png")
BoringFPS_CONFIG.Icons.DisconnectedIcon = Material("boringfps/icons/skull_icon.png")
BoringFPS_CONFIG.Icons.InfiniteIcon = Material("boringfps/icons/infinite_icon.png")
BoringFPS_CONFIG.Icons.CircleIcon = Material("boringfps/ui/circle_ui.png")

BoringFPS_CONFIG.Icons.PistolClass = Material("boringfps/class/pistol.png")
BoringFPS_CONFIG.Icons.ShotGunClass = Material("boringfps/class/shotgun.png")
BoringFPS_CONFIG.Icons.LauncherClass = Material("boringfps/class/rocket-launcher.png")
BoringFPS_CONFIG.Icons.CrowbarClass = Material("boringfps/class/crowbar.png")
BoringFPS_CONFIG.Icons.TouchClass = Material("boringfps/class/touch.png")
BoringFPS_CONFIG.Icons.StalkerClass = Material("boringfps/class/stalker.png")

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
BoringFPS_CONFIG.Settings.MinVelocityKnockBackDamage = 500 -- Define the minimum velocity for knockback damage
BoringFPS_CONFIG.Settings.MaxVelocityKnockBackDamage = 1000 -- Define the maximum velocity for knockback damage
BoringFPS_CONFIG.Settings.MinDamageKnockBack = 10 -- Define the minimum damage that can be applied from knockback
BoringFPS_CONFIG.Settings.MaxDamageKnockBack = 30 -- Define the maximum damage that can be applied from knockback
BoringFPS_CONFIG.Settings.ListClass = {
    "pistol",
    "shootgun",
    "launcher",
    "crowbar",
    "touch",
    "stalker"
}
BoringFPS_CONFIG.Settings.ClassWeapon = {
    ["pistol"] = "pistol_boring-gun",
    ["shootgun"] = "shootgun_boring-gun",
    ["launcher"] = "launcher_boring-gun",
    ["crowbar"] = "crowbar_boring-gun",
    ["touch"] = "touch_touch_boring-gun",
    ["stalker"] = "stalker_boring-gun"

}
BoringFPS_CONFIG.Settings.HideHUD = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudChat"] = true,
    ["CHudDeathNotice"] = true
}
BoringFPS_CONFIG.Settings.IconsClass = {
    ["pistol"] = BoringFPS_CONFIG.Icons.PistolClass,
    ["shootgun"] = BoringFPS_CONFIG.Icons.ShotGunClass,
    ["launcher"] = BoringFPS_CONFIG.Icons.LauncherClass,
    ["crowbar"] = BoringFPS_CONFIG.Icons.CrowbarClass,
    ["touch"] = BoringFPS_CONFIG.Icons.TouchClass,
    ["stalker"] = BoringFPS_CONFIG.Icons.StalkerClass
}
BoringFPS_CONFIG.Settings.ColorPlayer = {
    Color(255, 85, 85),
    Color(85, 255, 85),
    Color(85, 85, 255),
    Color(255, 255, 85),
    Color(255, 85, 255),
    Color(85, 255, 255),
    Color(255, 170, 0),
    Color(170, 0, 255),
    Color(0, 170, 255),
    Color(0, 255, 170),
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

-- Sounds
BoringFPS_CONFIG.Sounds = {}
BoringFPS_CONFIG.Sounds.TurnStart = Sound("boring_fps/sfx/turn/turn_start.mp3")
BoringFPS_CONFIG.Sounds.TurnEnd = Sound("boring_fps/sfx/turn/turn_end.mp3")
BoringFPS_CONFIG.Sounds.WinGame = Sound("boring_fps/sfx/turn/win_game.mp3")
BoringFPS_CONFIG.Sounds.OnUse = Sound("boring_fps/sfx/ui/on_use.mp3")
BoringFPS_CONFIG.Sounds.RevealAura = Sound("boring_fps/sfx/game/reveal_aura.mp3")
BoringFPS_CONFIG.Sounds.GameMusic = {
    "boring_fps/music/theme_boringfps_1.wav",
    "boring_fps/music/theme_boringfps_2.wav",
    "boring_fps/music/theme_boringfps_3.wav",
    "boring_fps/music/theme_boringfps_4.wav"
}

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
BoringFPS_CONFIG.NetVar.StartClientPreGame = "BoringFPS_CONFIG.StartClientPreGame"
BoringFPS_CONFIG.NetVar.StopClientPreGame = "BoringFPS_CONFIG.StopClientPreGame"

-- Base vars, i really don't recommend to edit this section
BoringFPS_CONFIG.Vars = {}
BoringFPS_CONFIG.Vars.PlayersInGame = {}
BoringFPS_CONFIG.Vars.GameLogs = {}
BoringFPS_CONFIG.Vars.PlayersAlive = {}
BoringFPS_CONFIG.Vars.ColorBox = {}