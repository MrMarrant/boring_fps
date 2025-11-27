local EN = {
    help = "Help",
    help_desc = "This is the help page of Boring FPS. Here you can find information about the game, its rules, and how to play.",
    start_game = "Start Game",
    not_enough_spawns = "Not enough spawn points for all players. You have been put into spectator mode.",

    -- Rules
    rule = "Game rules",
    rule_desc = "The goal of the game is to be the last survivor in the current game.\nYou take turns playing for a set amount of time.\nYou can perform actions during your turn, as well as when it is not your turn.\nYou can choose from several classes, each of which gives you access to a unique weapon and unique characteristics in the pregame lobby.",
    turn_comp = "Current turn",
    turn_indication = "- Use an action\n  → Shoot\n  → Special weapon action\n  → Reload\n\n - Use movement points",
    out_turn_comp = "Outside your turn",
    out_of_turn_indication = "- Use your dash points to avoid\nfire",
    legend = "Legend",
    action_point = "Action points",
    move_point = "Movement points",
    dash_point = "Dash points",
    ammo_left = "Ammo remaining",
    turn_time = "Time remaining in turn",

    -- Weapons
    launcher_description = "The Launcher is a heavy class that fires explosive rockets that inflict area damage. The damage depends on the distance traveled (the longer the rocket travels, the less damage it inflicts).\n\nThe Launcher is slow and has few action points, but compensates for this with high damage. Furthermore, when firing, you suffer significant recoil, causing you to be knocked back several meters.",
    crowbar_description = "A simple crowbar, you have a lot of movement and dash points.\n\nYou can attack in close combat with your crowbar, inflicting moderate damage at short range.",
    touch_description = "The goal of this class is to touch as many players as possible with your weapon.\nIf you have touched at least one player, you can right-click to explode each player you have touched.\nYou have an indicator on the HUD for each player you have touched.\nOnce exploded, you become invisible until the end of your turn.",
    stalker_description = "A weapon that can shoot players through any walls.\nIn addition, you can reveal the positions of all other players for a short time by right-clicking. However, doing so will also reveal your position.",
    pistol_description = "A simple pistol that can double damage when aiming at the head.\nAdditionally, you can return to your starting position at the beginning of your turn by right-clicking.",
    shotgun_description = "A powerful short-range weapon that causes significant recoil to the player hit.\nIf a player suffering recoil hits a wall, they will take additional damage.",
    invalid_weapon = "Invalid class weapon.",
    change_class = "You have changed your class weapon to: %s",
    touch_explode = "You have exploded the players you touched.",

    -- Game
    move_point_empty = "You have used all your movement points.",
    wait_state = "You are in a waiting state.",
    play_state = "You are currently playing.",
    ff_disabled = "The conditions are not met ...",
    ff_activated = "%s has forfeited.",
    exp_gained = "You have gained %d experience points.",
    level_up = "Congratulations! You have reached level %d !",
    player_killed = "%s was killed by %s.",
    player_died = "%s has died.",
    on_hit = "%s was hit by %s and received\n %d damage.",
    turn_to_play = "%s's turn to play!",
    turn_ended = "%s's turn has ended.",
    turn_end = "Turn has ended!",
    start_end_game_event = "Starting end game event!",
    endgame_hit = "%s received %d damage\n from end game event!"
}

BoringFPS.AddLanguage("en", EN)
