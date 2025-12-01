-- Convars

-- [SETTINGS]
local timerPreGame 	= CreateConVar("bfps_timer_pregame", "5", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Time in seconds before the game starts")
local timerPostGame = CreateConVar("bfps_timer_postgame", "5", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Duration before game restart")
local timerDelayNextGame = CreateConVar("bfps_timer_delay_nextgame", "20", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Duration before next game starts")
local baseHP = CreateConVar("bfps_base_hp", "100", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Default health points for players", 1)
local minPlayerRequired = CreateConVar("bfps_min_player_required", "2", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Minimum players required to start a game")
local limitTimeTurn = CreateConVar("bfps_limit_time_turn", "10", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Time limit for each player's turn", 5)
local timerBetweenTurns = CreateConVar("bfps_timer_between_turns", "1", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Time limit between each player's turn")
local defaultWalkSpeed = CreateConVar("bfps_default_walk_speed", "250", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Default walk speed for players")
local defaultRunSpeed = CreateConVar("bfps_default_run_speed", "320", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Default run speed for players")
local durationAnnouncerTurn = CreateConVar("bfps_duration_announcer_turn", "3", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Define how much time announcer turn stay on screen")
local messageLifetimeChatBox = CreateConVar("bfps_message_lifetime_chatbox", "8", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Define how much time messages chatbox history are displayed.")
local minVelocityKnockBackDamage = CreateConVar("bfps_min_velocity_knockback_damage", "100", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Define the minimum velocity for knockback damage")
local maxVelocityKnockBackDamage = CreateConVar("bfps_max_velocity_knockback_damage", "350", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Define the maximum velocity for knockback damage")
local minDamageKnockBack = CreateConVar("bfps_min_damage_knockback", "5", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Define the minimum damage that can be applied from knockback")
local maxDamageKnockBack = CreateConVar("bfps_max_damage_knockback", "40", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Define the maximum damage that can be applied from knockback")
local globalTurnEndGame = CreateConVar("bfps_global_turn_endgame", "10", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Define the global turn where endgame can start")
local damageEndGame = CreateConVar("bfps_damage_endgame", "10", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Define the damage to deal to player when endgame event is enabled", 1)
local durationRevealEndGame = CreateConVar("bfps_duration_reveal_endgame", "3", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Define how long players are reveal when endgame event is enabled")
local roundsBeforeChangeMap = CreateConVar("bfps_rounds_before_change_map", "3", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Define how many rounds before changing map")
local timerForVote = CreateConVar("bfps_timer_for_vote", "10", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Define how much time players have to vote for next map", 1)

-- [EXPERIENCE]
local expGainByGame = CreateConVar("bfps_experience_gain_by_game", "100", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Experience gained by player at the end of each game")
local expBonusWinner = CreateConVar("bfps_experience_bonus_winner", "25", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Experience bonus gained by the winner at the end of each game")
local expGainByKill = CreateConVar("bfps_experience_gain_by_kill", "10", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Experience gained by player per kill")
local differenceExperienceBetweenLevels = CreateConVar("bfps_difference_experience_between_levels", "100", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "The experience needed to level up is calculated with the formula : (DifferenceExperienceBetweenLevels / 2) * CurrentLevel * (CurrentLevel + 1)", 1)
local maxLevel = CreateConVar("bfps_max_level", "70", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Maximum level a player can reach")
local botEnableExp = CreateConVar("bfps_bot_enable_experience", "0", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Set to 1 if you want bots to gain exp & level")
-- END Convars

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

-- Game settings
BoringFPS_CONFIG.Settings = {}
BoringFPS_CONFIG.Settings.TimerPreGame = timerPreGame:GetInt() -- Time in seconds before the game starts
BoringFPS_CONFIG.Settings.TimerPostGame = timerPostGame:GetInt() -- Duration before game restart
BoringFPS_CONFIG.Settings.TimerDelayNextGame = timerDelayNextGame:GetInt() -- Duration before next game starts
BoringFPS_CONFIG.Settings.BaseHP = baseHP:GetInt() -- Default health points for players
BoringFPS_CONFIG.Settings.MinPlayerRequired = minPlayerRequired:GetInt() -- Minimum players required to start a game
BoringFPS_CONFIG.Settings.LimitTimeTurn = limitTimeTurn:GetInt() -- Time limit for each player's turn
BoringFPS_CONFIG.Settings.TimerBetweenTurns = timerBetweenTurns:GetInt() -- Time limit between each player's turn
BoringFPS_CONFIG.Settings.DefaultWalkSpeed = defaultWalkSpeed:GetInt() -- Default walk speed for players
BoringFPS_CONFIG.Settings.DefaultRunSpeed = defaultRunSpeed:GetInt() -- Default run speed for players
BoringFPS_CONFIG.Settings.DurationAnnouncerTurn = durationAnnouncerTurn:GetInt() -- Define how much time announcer turn stay on screen
BoringFPS_CONFIG.Settings.MessageLifetimeChatBox = messageLifetimeChatBox:GetInt() -- Define how much time messages chatbox history are displayed.
BoringFPS_CONFIG.Settings.MinVelocityKnockBackDamage = minVelocityKnockBackDamage:GetInt() -- Define the minimum velocity for knockback damage
BoringFPS_CONFIG.Settings.MaxVelocityKnockBackDamage = maxVelocityKnockBackDamage:GetInt() -- Define the maximum velocity for knockback damage
BoringFPS_CONFIG.Settings.MinDamageKnockBack = minDamageKnockBack:GetInt() -- Define the minimum damage that can be applied from knockback
BoringFPS_CONFIG.Settings.MaxDamageKnockBack = maxDamageKnockBack:GetInt() -- Define the maximum damage that can be applied from knockback
BoringFPS_CONFIG.Settings.GlobalTurnEndGame = globalTurnEndGame:GetInt() -- Define the global turn where endgame can start
BoringFPS_CONFIG.Settings.DamageEndGame = damageEndGame:GetInt() -- Define the damage to deal to player when end game event is enabled
BoringFPS_CONFIG.Settings.DurationRevealEndGame = durationRevealEndGame:GetInt() -- Define how long players are reveal when endgame event is enabled
BoringFPS_CONFIG.Settings.RoundsBeforeChangeMap = roundsBeforeChangeMap:GetInt() -- Define how many rounds before changing map
BoringFPS_CONFIG.Settings.TimerForVote = timerForVote:GetInt() -- Define how much time players have to vote for next map

-- Experience System
BoringFPS_CONFIG.Settings.ExperienceGainByGame = expGainByGame:GetInt() -- Experience gained by player at the end of each game
BoringFPS_CONFIG.Settings.ExperienceBonusWinner = expBonusWinner:GetInt() -- Experience gained by player at the end of each game
BoringFPS_CONFIG.Settings.ExperienceGainByKill = expGainByKill:GetInt() -- Experience gained by player at the end of each game
BoringFPS_CONFIG.Settings.DifferenceExperienceBetweenLevels = differenceExperienceBetweenLevels:GetInt() -- The experience needed to level up is calculated with the formula : (DifferenceExperienceBetweenLevels / 2) * CurrentLevel * (CurrentLevel + 1)
BoringFPS_CONFIG.Settings.MaxLevel = maxLevel:GetInt() -- Maximum level a player can reach
BoringFPS_CONFIG.Settings.BotEnable = botEnableExp:GetBool() -- Define if bot can gain exp & level

-- Weapons Settings
BoringFPS_CONFIG.Settings.Weapons = {}
BoringFPS_CONFIG.Settings.Weapons["pistol"] = {
    ClassName = "pistol_boring-gun",
    Name = "Pistol",
    IconClass = BoringFPS_CONFIG.Icons.PistolClass,
    MaxAmmo = 4,
    Damage = 15,
    MaxStep = 10,
    MaxDash = 2,
    Action = 2,
    WalkSpeed = BoringFPS_CONFIG.Settings.DefaultWalkSpeed,
    RunSpeed = BoringFPS_CONFIG.Settings.DefaultRunSpeed,
    Description = "pistol_description"
}
BoringFPS_CONFIG.Settings.Weapons["shootgun"] = {
    ClassName = "shootgun_boring-gun",
    Name = "Shotgun",
    IconClass = BoringFPS_CONFIG.Icons.ShotGunClass,
    MaxAmmo = 2,
    Damage = 8,
    MaxStep = 8,
    MaxDash = 1,
    Action = 1,
    WalkSpeed = BoringFPS_CONFIG.Settings.DefaultWalkSpeed,
    RunSpeed = BoringFPS_CONFIG.Settings.DefaultRunSpeed,
    Description = "shotgun_description"
}
BoringFPS_CONFIG.Settings.Weapons["launcher"] = {
    ClassName = "launcher_boring-gun",
    Name = "Launcher",
    IconClass = BoringFPS_CONFIG.Icons.LauncherClass,
    MaxAmmo = 2,
    Damage = 100,
    MaxStep = 6,
    MaxDash = 1,
    Action = 1,
    WalkSpeed = BoringFPS_CONFIG.Settings.DefaultWalkSpeed,
    RunSpeed = BoringFPS_CONFIG.Settings.DefaultRunSpeed,
    Description = "launcher_description"
}
BoringFPS_CONFIG.Settings.Weapons["crowbar"] = {
    ClassName = "crowbar_boring-gun",
    Name = "Crowbar",
    IconClass = BoringFPS_CONFIG.Icons.CrowbarClass,
    MaxAmmo = -1,
    Damage = 20,
    MaxStep = 18,
    MaxDash = 2,
    Action = 2,
    WalkSpeed = BoringFPS_CONFIG.Settings.DefaultWalkSpeed,
    RunSpeed = BoringFPS_CONFIG.Settings.DefaultRunSpeed,
    Description = "crowbar_description"
}
BoringFPS_CONFIG.Settings.Weapons["touch"] = {
    ClassName = "touch_touch_boring-gun",
    Name = "Touch",
    IconClass = BoringFPS_CONFIG.Icons.TouchClass,
    MaxAmmo = -1,
    Damage = 25,
    MaxStep = 20,
    MaxDash = 2,
    Action = 3,
    WalkSpeed = 400,
    RunSpeed = 470,
    Description = "touch_description"
}
BoringFPS_CONFIG.Settings.Weapons["stalker"] = {
    ClassName = "stalker_boring-gun",
    Name = "Stalker",
    IconClass = BoringFPS_CONFIG.Icons.StalkerClass,
    MaxAmmo = 2,
    Damage = 30,
    MaxStep = 5,
    MaxDash = 1,
    Action = 2,
    WalkSpeed = BoringFPS_CONFIG.Settings.DefaultWalkSpeed,
    RunSpeed = BoringFPS_CONFIG.Settings.DefaultRunSpeed,
    Description = "stalker_description"
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

-- SQL Settings
BoringFPS_CONFIG.SQL = {}
BoringFPS_CONFIG.SQL.TablePlayer = "boringfps_player"
BoringFPS_CONFIG.SQL.TableClassStat = "boringfps_classstat"
BoringFPS_CONFIG.SQL.UseDatabase = true -- Set to false if you don't want use database

-- Models
BoringFPS_CONFIG.Models = {}
BoringFPS_CONFIG.Models.Characters = {
    Model("models/player/breen.mdl"),
    Model("models/player/barney.mdl"),
    Model("models/player/Group01/male_07.mdl"),
    Model("models/player/gman_high.mdl"),
    Model("models/player/alyx.mdl"),
    Model("models/player/combine_super_soldier.mdl"),
    Model("models/player/police.mdl"),
    Model("models/player/monk.mdl"),
    Model("models/player/corpse1.mdl"),
    Model("models/player/soldier_stripped.mdl")
}
BoringFPS_CONFIG.Models.Rocket = Model("models/props_c17/doll01.mdl")
BoringFPS_CONFIG.Models.SelectionClass = Model("models/props_borealis/bluebarrel001.mdl") --? Default model of the entity if none was set from hammer param
BoringFPS_CONFIG.Models.HatModels = {
    [0]  = Model("models/hats/hat_new/hat_new.mdl"),
    [10] = Model("models/hats/hat_10/hat_10.mdl"),
    [20] = Model("models/hats/hat_10/hat_10.mdl"),
    [30] = Model("models/hats/hat_10/hat_10.mdl"),
    [40] = Model("models/hats/hat_40/hat_40.mdl"),
    [50] = Model("models/hats/hat_40/hat_40.mdl"),
    [60] = Model("models/hats/hat_40/hat_40.mdl"),
    [70] = Model("models/hats/hat_70/hat_70.mdl")
}
BoringFPS_CONFIG.Models.BodyGroupHat = {
    [0]  = "000",
    [10] = "000",
    [20] = "010",
    [30] = "011",
    [40] = "000",
    [50] = "010",
    [60] = "011",
    [70] = "000"
}

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
BoringFPS_CONFIG.NetVar.ChangeMap = "BoringFPS_CONFIG.ChangeMap"
BoringFPS_CONFIG.NetVar.VoteMap = "BoringFPS_CONFIG.VoteMap"

-- Base vars, i really don't recommend to edit this section
BoringFPS_CONFIG.Vars = {}
BoringFPS_CONFIG.Vars.PlayersInGame = {}
BoringFPS_CONFIG.Vars.GameLogs = {}
BoringFPS_CONFIG.Vars.PlayersAlive = {}
BoringFPS_CONFIG.Vars.ColorBox = {}
BoringFPS_CONFIG.Vars.NumberOfPlayers = 0
BoringFPS_CONFIG.Vars.CurrentRound = 0
BoringFPS_CONFIG.Vars.VoteMap = {}
BoringFPS_CONFIG.Vars.PlayersVoteMap = {}

-- Convar Change Callbacks
cvars.AddChangeCallback("bfps_timer_pregame", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.TimerPreGame = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_timer_postgame", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.TimerPostGame = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_timer_delay_nextgame", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.TimerDelayNextGame = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_base_hp", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.BaseHP = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_min_player_required", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.MinPlayerRequired = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_limit_time_turn", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.LimitTimeTurn = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_timer_between_turns", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.TimerBetweenTurns = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_default_walk_speed", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.DefaultWalkSpeed = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_default_run_speed", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.DefaultRunSpeed = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_duration_announcer_turn", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.DurationAnnouncerTurn = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_message_lifetime_chatbox", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.MessageLifetimeChatBox = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_min_velocity_knockback_damage", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.MinVelocityKnockBackDamage = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_max_velocity_knockback_damage", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.MaxVelocityKnockBackDamage = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_min_damage_knockback", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.MinDamageKnockBack = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_max_damage_knockback", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.MaxDamageKnockBack = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_global_turn_endgame", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.GlobalTurnEndGame = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_damage_endgame", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.DamageEndGame = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_duration_reveal_endgame", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.DurationRevealEndGame = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_rounds_before_change_map", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.RoundsBeforeChangeMap = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_timer_for_vote", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.TimerForVote = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_experience_gain_by_game", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.ExperienceGainByGame = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_experience_bonus_winner", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.ExperienceBonusWinner = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_experience_gain_by_kill", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.ExperienceGainByKill = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_difference_experience_between_levels", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.differenceExperienceBetweenLevels = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_max_level", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.MaxLevel = tonumber(value_new)
end)
cvars.AddChangeCallback("bfps_bot_enable_experience", function(convar_name, value_old, value_new)
    BoringFPS_CONFIG.Settings.BotEnable = tobool(tonumber(value_new))
end)