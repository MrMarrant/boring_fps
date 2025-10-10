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
BoringFPS_CONFIG.Icons.Info = Material("boringfps/icons/info.png")
BoringFPS_CONFIG.Icons.RulesIcon = Material("boringfps/icons/rules.png")

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
BoringFPS_CONFIG.Settings.MinPlayerRequired = 3 -- Minimum players required to start a game
BoringFPS_CONFIG.Settings.LimitTimeTurn = 10 -- Time limit for each player's turn
BoringFPS_CONFIG.Settings.TimerBetweenTurns = 1 -- Time limit between each player's turn
BoringFPS_CONFIG.Settings.DefaultMaxStep = 10 -- Default steps a player can do during his turn
BoringFPS_CONFIG.Settings.DefaultWalkSpeed = 250 -- Default walk speed for players
BoringFPS_CONFIG.Settings.DefaultRunSpeed = 320 -- Default run speed for players
BoringFPS_CONFIG.Settings.DurationAnnouncerTurn = 3 -- Define how much time announcer turn stay on screen
BoringFPS_CONFIG.Settings.MessageLifetimeChatBox = 8 -- Define how much time messages chatbox history are displayed.
BoringFPS_CONFIG.Settings.MinVelocityKnockBackDamage = 100 -- Define the minimum velocity for knockback damage
BoringFPS_CONFIG.Settings.MaxVelocityKnockBackDamage = 350 -- Define the maximum velocity for knockback damage
BoringFPS_CONFIG.Settings.MinDamageKnockBack = 5 -- Define the minimum damage that can be applied from knockback
BoringFPS_CONFIG.Settings.MaxDamageKnockBack = 40 -- Define the maximum damage that can be applied from knockback
BoringFPS_CONFIG.Settings.GlobalTurnEndGame = 10 -- Define the global turn where endgame can start
BoringFPS_CONFIG.Settings.DamageEndGame = 10 -- Define the damage to deal to player when end game event is enabled
BoringFPS_CONFIG.Settings.DurationRevealEndGame = 3 -- Define how long players are reveal when endgame event is enabled
BoringFPS_CONFIG.Settings.Weapons = {}
BoringFPS_CONFIG.Settings.Weapons["pistol"] = {
    ClassName = "pistol_boring-gun",
    IconClass = BoringFPS_CONFIG.Icons.PistolClass,
    MaxAmmo = 4,
    Damage = 15,
    MaxStep = 10,
    MaxDash = 2,
    Action = 2,
    WalkSpeed = BoringFPS_CONFIG.Settings.DefaultWalkSpeed,
    RunSpeed = BoringFPS_CONFIG.Settings.DefaultRunSpeed
}
BoringFPS_CONFIG.Settings.Weapons["shootgun"] = {
    ClassName = "shootgun_boring-gun",
    IconClass = BoringFPS_CONFIG.Icons.ShotGunClass,
    MaxAmmo = 2,
    Damage = 8,
    MaxStep = 8,
    MaxDash = 1,
    Action = 1,
    WalkSpeed = BoringFPS_CONFIG.Settings.DefaultWalkSpeed,
    RunSpeed = BoringFPS_CONFIG.Settings.DefaultRunSpeed
}
BoringFPS_CONFIG.Settings.Weapons["launcher"] = {
    ClassName = "launcher_boring-gun",
    IconClass = BoringFPS_CONFIG.Icons.LauncherClass,
    MaxAmmo = 2,
    Damage = 100,
    MaxStep = 6,
    MaxDash = 1,
    Action = 1,
    WalkSpeed = BoringFPS_CONFIG.Settings.DefaultWalkSpeed,
    RunSpeed = BoringFPS_CONFIG.Settings.DefaultRunSpeed
}
BoringFPS_CONFIG.Settings.Weapons["crowbar"] = {
    ClassName = "crowbar_boring-gun",
    IconClass = BoringFPS_CONFIG.Icons.CrowbarClass,
    MaxAmmo = -1,
    Damage = 20,
    MaxStep = 18,
    MaxDash = 2,
    Action = 2,
    WalkSpeed = BoringFPS_CONFIG.Settings.DefaultWalkSpeed,
    RunSpeed = BoringFPS_CONFIG.Settings.DefaultRunSpeed
}
BoringFPS_CONFIG.Settings.Weapons["touch"] = {
    ClassName = "touch_touch_boring-gun",
    IconClass = BoringFPS_CONFIG.Icons.TouchClass,
    MaxAmmo = -1,
    Damage = 25,
    MaxStep = 20,
    MaxDash = 2,
    Action = 3,
    WalkSpeed = 400,
    RunSpeed = 470
}
BoringFPS_CONFIG.Settings.Weapons["stalker"] = {
    ClassName = "stalker_boring-gun",
    IconClass = BoringFPS_CONFIG.Icons.StalkerClass,
    MaxAmmo = 2,
    Damage = 30,
    MaxStep = 5,
    MaxDash = 1,
    Action = 2,
    WalkSpeed = BoringFPS_CONFIG.Settings.DefaultWalkSpeed,
    RunSpeed = BoringFPS_CONFIG.Settings.DefaultRunSpeed
}
BoringFPS_CONFIG.Settings.ListClass = {
    "pistol",
    "shootgun",
    "launcher",
    "crowbar",
    "touch",
    "stalker"
}
BoringFPS_CONFIG.Settings.HideHUD = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudChat"] = true,
    ["CHudDeathNotice"] = true
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

-- Experience System
BoringFPS_CONFIG.Settings.ExperienceGainByGame = 100 -- Experience gained by player at the end of each game
BoringFPS_CONFIG.Settings.ExperienceBonusWinner = 25 -- Experience gained by player at the end of each game
BoringFPS_CONFIG.Settings.ExperienceGainByKill = 10 -- Experience gained by player at the end of each game
BoringFPS_CONFIG.Settings.DifferenceExperienceBetweenLevels = 100 -- The experience needed to level up is calculated with the formula : (DifferenceExperienceBetweenLevels / 2) * CurrentLevel * (NextLevel)

-- SQL Settings
BoringFPS_CONFIG.SQL = {}
BoringFPS_CONFIG.SQL.TablePlayer = "boringfps_player"
BoringFPS_CONFIG.SQL.TableClassStat = "boringfps_classstat"
BoringFPS_CONFIG.SQL.UseDatabase = true

-- Models
BoringFPS_CONFIG.Models = {}
BoringFPS_CONFIG.Models.Characters = {
    "models/player/breen.mdl",
    "models/player/barney.mdl",
    "models/player/Group01/male_07.mdl",
    "models/player/gman_high.mdl",
    "models/player/alyx.mdl",
    "models/player/combine_super_soldier.mdl",
    "models/player/police.mdl",
    "models/player/monk.mdl",
    "models/player/corpse1.mdl",
    "models/player/soldier_stripped.mdl"
}
BoringFPS_CONFIG.Models.Rocket = Model("models/props_c17/doll01.mdl")
BoringFPS_CONFIG.Models.SelectionClass = Model("models/props_borealis/bluebarrel001.mdl") --? Default model of the entity if none was set from hammer param

-- Sounds
BoringFPS_CONFIG.Sounds = {}
BoringFPS_CONFIG.Sounds.TurnStart = Sound("boring_fps/sfx/turn/turn_start.mp3")
BoringFPS_CONFIG.Sounds.TurnEnd = Sound("boring_fps/sfx/turn/turn_end.mp3")
BoringFPS_CONFIG.Sounds.NotifTurnEnd = Sound("boring_fps/sfx/turn/notif_turn_end.mp3")
BoringFPS_CONFIG.Sounds.WinGame = Sound("boring_fps/sfx/turn/win_game.mp3")
BoringFPS_CONFIG.Sounds.OnUse = Sound("boring_fps/sfx/ui/on_use.mp3")
BoringFPS_CONFIG.Sounds.RevealAura = Sound("boring_fps/sfx/game/reveal_aura.mp3")
BoringFPS_CONFIG.Sounds.Detonate = Sound("boring_fps/sfx/game/detonate.mp3")
BoringFPS_CONFIG.Sounds.DeathSound = Sound("boring_fps/sfx/ded.mp3")
BoringFPS_CONFIG.Sounds.EndEventMusic = Sound("boring_fps/music/end_music.wav")
BoringFPS_CONFIG.Sounds.GameMusic = {
    "boring_fps/music/theme_boringfps_1.wav",
    "boring_fps/music/theme_boringfps_2.wav",
    "boring_fps/music/theme_boringfps_3.wav",
    "boring_fps/music/theme_boringfps_4.wav"
}

-- Links
BoringFPS_CONFIG.Links = {}
BoringFPS_CONFIG.Links.PatchNote = "https://pastebin.com/raw/TfVkDPqP"

-- NET VAR
BoringFPS_CONFIG.NetVar = {}
BoringFPS_CONFIG.NetVar.StartClientPlay = "BoringFPS_CONFIG.StartClientPlay"
BoringFPS_CONFIG.NetVar.StopClientTurn = "BoringFPS_CONFIG.StopClientTurn"
BoringFPS_CONFIG.NetVar.StartClientWait = "BoringFPS_CONFIG.StartClientWait"
BoringFPS_CONFIG.NetVar.StartClientHUDGame = "BoringFPS_CONFIG.StartClientHUDGame"
BoringFPS_CONFIG.NetVar.EndGame = "BoringFPS_CONFIG.StopClientHUDGame"
BoringFPS_CONFIG.NetVar.SetGlobalTable = "BoringFPS_CONFIG.SetGlobalTable"
BoringFPS_CONFIG.NetVar.InsertLogs = "BoringFPS_CONFIG.InsertLogs"
BoringFPS_CONFIG.NetVar.StartClientPreGame = "BoringFPS_CONFIG.StartClientPreGame"
BoringFPS_CONFIG.NetVar.StopClientPreGame = "BoringFPS_CONFIG.StopClientPreGame"
BoringFPS_CONFIG.NetVar.RevealAura = "BoringFPS_CONFIG.RevealAura"
BoringFPS_CONFIG.NetVar.OpenHelpMenu = "BoringFPS_CONFIG.OpenHelpMenu"

-- Base vars, i really don't recommend to edit this section
BoringFPS_CONFIG.Vars = {}
BoringFPS_CONFIG.Vars.PlayersInGame = {}
BoringFPS_CONFIG.Vars.GameLogs = {}
BoringFPS_CONFIG.Vars.PlayersAlive = {}
BoringFPS_CONFIG.Vars.ColorBox = {}
BoringFPS_CONFIG.Vars.NumberOfPlayers = 0