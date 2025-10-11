local EN = {
    help = "Help",
    help_desc = "This is the help page of Boring FPS. Here you can find information about the game, its rules, and how to play.",
    start_game = "Start Game",

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

    -- Weapons
    launcher_description = "Le Launcher est une classe lourde, vous tirer des roquettes explosives qui infligent des dégâts de zone. en fonction de la distance parcourue (plus la roquette parcourt une longue distance, moins elle inflige de dégâts).\n\nLe Launcher est lent et possède peu de points d’action, mais compense cela avec des dégâts élevés, de plus en tirant, vous subissez un recul important vous faisant reculer de plusieurs mètres.",
    crowbar_description = "Une simple crowbar, vous avez beaucoup de points de mouvements et de dash.\n\nVous pouvez attaquer au corps à corps avec votre crowbar, infligeant des dégâts modérés à courte portée.",
    touch_description = "Le but de cette classe est de toucher le plus de joueur possible avec votre arme.\nSi vous avez touché au moins un joueur, vous pourrez via le clic droit, exploser chaque joueurs touchés.\nVous avez un indicateur sur l'HUD pour chaque joueur touché.\nUne fois explosé, vous devenez invisible jusqu'à la fin de votre tour.",
    stalker_description = "Une arme pouvant tirer sur les joueurs à travers n'importe quel murs.\nDe plus vous pouvez révéler la positions de tout les autres joueurs pendant une courte durée via le clic droit. Cependant se faisant, vous révélez votre position aussi.",
    pistol_description = "Un simple pistolet, pouvant doubler les dégâts en visant la tête.\nDe plus, vous pouvez revenir à votre position de début de votre tour via le clic droit.",
    shotgun_description = "Une arme puissante à courte portée infligeant un recul important au joueur touché.\nSi un joueur subissant un recul touche un mur, il subira des dégâts supplémentaires.",
}

BoringFPS.AddLanguage("en", EN)
