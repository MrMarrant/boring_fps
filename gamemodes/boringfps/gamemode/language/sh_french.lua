local FR = {
    help = "Aide",
    help_desc = "Voici la page d'aide de Boring FPS. Vous trouverez ici des informations sur le jeu, ses règles et comment y jouer.",
    start_game = "Démarrer le jeu",
    not_enough_spawns = "Il n'y a pas assez de points d'apparition pour tous les joueurs. Vous avez été mis en mode spectateur.",

    -- Help Menu
    class_helper = "Guide Classe",
    help_select_class = "Sélection Classe",

    -- Rules
    rule = "Règle du jeu",
    rule_desc = "Le but du jeu est d’être le dernier survivant de la partie en cours.\nVous jouez chacun votre tour, pendant une durée définie.\nVous pouvez réaliser des actions durant votre tour, ainsi que lorsque ce n’est pas votre tour.\nVous avez le choix entre plusieurs classes, chacune vous donnera accès à une arme unique ainsi que des caractéristiques uniques dans le salon du lobby de pregame.",
    turn_comp = "Tour actuel",
    turn_indication = "- Utiliser une action\n  → Tirer\n  → Action spéciale de l’arme\n  → Recharger\n\n- Utiliser les points de déplacements",
    out_turn_comp = "En dehors de votre tour",
    out_of_turn_indication = "- Utiliser vos points de dash pour éviter\nles tirs",
    legend = "Légende",
    action_point = "Points d’action",
    move_point = "Points de mouvements",
    dash_point = "Points de dash",
    ammo_left = "Munition restante",
    turn_time = "Temps restant du tour",
    
    -- Helper Class
    description_class = "Description",
    stats_class = "Stats",
    action_class = "Points d’action",
    move_class = "Points de mouvements",
    dash_class = "Points de dash",
    ammos_class = "Munitions max",
    walkspeed_class = "Vitesse de déplacement",

    -- HUD
    select_class = "Sélectionnez une classe",
    wait_join = "En attente de joueurs...",
    game_starting_in = "Le jeu va bientôt commencer...",
    starting_new_game_in = "Démarrage d'une nouvelle partie dans %d secondes...",

    -- Weapons
    launcher_description = "Le Launcher est une classe lourde, vous tirer des roquettes explosives qui infligent des dégâts de zone. en fonction de la distance parcourue (plus la roquette parcourt une longue distance, moins elle inflige de dégâts).\n\nLe Launcher est lent et possède peu de points d’action, mais compense cela avec des dégâts élevés, de plus en tirant, vous subissez un recul important vous faisant reculer de plusieurs mètres.",
    crowbar_description = "Une simple crowbar, vous avez beaucoup de points de mouvements et de dash.\n\nVous pouvez attaquer au corps à corps avec votre crowbar, infligeant des dégâts modérés à courte portée.",
    touch_description = "Le but de cette classe est de toucher le plus de joueur possible avec votre arme.\nSi vous avez touché au moins un joueur, vous pourrez via le clic droit, exploser chaque joueurs touchés.\nVous avez un indicateur sur l'HUD pour chaque joueur touché.\nUne fois explosé, si vouis avez touchés tout les joueurs encore en vie, vous devenez invisible jusqu'à la fin de votre tour.",
    stalker_description = "Une arme pouvant tirer sur les joueurs à travers n'importe quel murs.\nDe plus vous pouvez révéler la positions de tout les autres joueurs pendant une courte durée via le clic droit. Cependant se faisant, vous révélez votre position aussi.",
    pistol_description = "Un simple pistolet, pouvant doubler les dégâts en visant la tête.\nDe plus, vous pouvez revenir à votre position de début de votre tour via le clic droit.",
    shotgun_description = "Une arme puissante à courte portée infligeant un recul important au joueur touché.\nSi un joueur subissant un recul touche un mur, il subira des dégâts supplémentaires.",
    invalid_weapon = "Arme de classe non valide.",
    change_class = "Vous avez changé votre classe d'arme par : %s",
    touch_explode = "Vous avez fait exploser les joueurs que vous avez touchés.",

    -- Game
    move_point_empty = "Vous avez utilisé tous vos points de mouvement.",
    wait_state = "Vous êtes en attente.",
    play_state = "Vous êtes en train de jouer.",
    ff_disabled = "Les conditions ne sont pas remplies...",
    ff_activated = "%s a abandonné. ",
    exp_gained = "Vous avez gagné %d points d'expérience.",
    level_up = "Félicitations ! Vous avez atteint le niveau %d!",
    player_killed = "%s a été tué par %s.",
    player_died = "%s est mort.",
    on_hit = "%s a été touché par %s et a subi\n %d points de dégâts.",
    turn_to_play = "C'est au tour de %s de jouer !",
    turn_ended = "Le tour de %s est terminé.",
    turn_end = "Le tour est terminé !",
    start_end_game_event = "Début de l'événement de fin de partie !",
    endgame_hit = "%s a subi %d points de dégâts\n lors de l'événement de fin de partie !",
    turn = "Tour %d"
}

BoringFPS.AddLanguage("fr", FR)
