/obj/card
    proc/show_preview()
        if(!usr || !usr.client)
            return
        // Show the window
        winshow(usr, "card_info", 1)
        var/current_display_name = name
        if (face_state == "down" && stored_name)
            name = stored_name
        // Set background color and image based on card type
        var/background_color
        var/background_image
        var/star_image
        switch(card_data.card_type)
            if("Effect Monster")
                background_color = "#bc6e40"  // Bronze color for effect monsters
                background_image = 'frames/monster.png'
                star_image='frames/effectmonsterstar.png'
            if("Normal Monster")
                background_color = "#bc6e40"  // Orange-yellow for normal monsters
                background_image = 'frames/monster.png'
                star_image='frames/effectmonsterstar.png'
            if("Fusion Monster")
                background_color = "#92509c"  // Purple for fusion monsters
                background_image = 'frames/fusion_monster.png'
                star_image='frames/fusionmonsterstar.png'
            if("Synchro Monster")
                background_color = "#dededc"  // White for synchro monsters
                background_image = 'frames/synchro_monster.png'
                star_image='frames/synchromonsterstar.png'
            if("Ritual Monster")
                background_color = "#5478b7"  // Royal blue for ritual monsters
                background_image = 'frames/ritual_monster.png'
                star_image='frames/ritualmonsterstar.png'
            if("Spell Card")
                background_color = "#32CD32"  // Green for spell cards
                background_image = 'frames/spell_card.png'
            if("Trap Card")
                background_color = "#FF69B4"  // Pink for trap cards
                background_image = 'frames/trap_card.png'
            else
                background_color = "#bc6e40"  // Default to normal monster color
                background_image = 'frames/monster.png'
        
        // Set the background color and image
        winset(usr, "card_info.card_frame", "image=[background_image]")
        // You might need to add more elements depending on your interface structure
        
        // Output basic info that all cards have
        usr << output(name, "card_info.card_name")
        usr << output(desc, "card_info.effect_text")
        usr << output("[card_data.humanReadableCardType]", "card_info.card_type")

        // Handle monster-specific elements
        if(card_data.card_type in list("Effect Monster", "Normal Monster", "Synchro Monster", "Fusion Monster", "Ritual Monster"))
            // Show monster-specific elements
            winset(usr, "card_info.attribute_icon", "is-visible=true")
            winset(usr, "card_info.atk_label", "is-visible=true")
            winset(usr, "card_info.def_label", "is-visible=true")
            
            // Output monster stats
            usr << output(icon('stars_and_attributes.dmi', "[lowertext(card_data.attribute)]_attribute"), "card_info.attribute_icon")
            usr << output("ATK/[card_data.atk]", "card_info.atk_label")
            usr << output("DEF/[card_data.def]", "card_info.def_label")
            
            // Handle level stars
            for(var/i = 1 to 12)
                var/star_elem = "card_info.star[i]"
                if(i <= card_data.level)
                    winset(usr, "card_info.star[i]", "is-visible=true")
                    winset(usr, "card_info.star[i]", "background-color=[background_color]")
                    winset(usr, "card_info.star[i]", "image=[star_image]")
                else
                    winset(usr, star_elem, "is-visible=false")
        else
            // Hide monster-specific elements for Spells/Traps
            winset(usr, "card_info.attribute_icon", "is-visible=false")
            winset(usr, "card_info.atk_label", "is-visible=false")
            winset(usr, "card_info.def_label", "is-visible=false")
            
            // Hide starstab and all level stars
            winset(usr, "card_info.starstab", "is-visible=false")
            for(var/i = 1 to 12)
                winset(usr, "card_info.star[i]", "is-visible=false")
        if (face_state== "down" && stored_name)
            name = current_display_name


/mob/proc/normal_summon(obj/card/monster/M)
    if(!M || !(M in hand))
        src << "That card is not in your hand!"
        return
    
    // Find all unoccupied monster zones owned by the player
    var/list/available_zones = list()
    for(var/obj/duel/zone/monster/Z in world)
        if(Z.owner == src && !Z.occupying_card)
            available_zones["Zone [Z.zone_id]"] = Z
        
    if(!available_zones.len)
        src << "No available monster zones!"
        return
    
    // Let the player choose a zone
    var/choice = input(src, "Select a monster zone:", "Normal Summon") as null|anything in available_zones
    if(!choice)
        return
    
    var/obj/duel/zone/monster/selected_zone = available_zones[choice]
    
    // Ask for position
    var/position = alert(src, "Choose position:", "Normal Summon", "Attack", "Set")
    
    // Complete the summoning
    place_monster_on_zone(M, selected_zone, position)
    
    src << "You summoned [M.name] in [lowertext(position)] position!"

/mob/proc/place_monster_on_zone(obj/card/monster/M, obj/duel/zone/monster/Z, position = "Attack", face = "up")
    // Remove from hand
    hand -= M
    
    // Update card and zone references
    M.current_zone = Z
    M.location = "field"
    Z.occupying_card = M
    
    // Set position and update visuals
    M.position_state = position
    M.face_state = face
    
    // Move the card to the zone's position
    M.loc = Z.loc
    
    // Create a new transform matrix starting with the zone's current transform
    // This preserves the field rotation
    var/matrix/transform_matrix = Z.transform
    
    // Apply additional transformations based on position
    if(position == "Set")
        // Add 90 degrees rotation for Set position relative to the zone's orientation
        transform_matrix.Turn(90)
        
        // Monsters in Set position are automatically set face-down
        M.face_state = "down"
        
        // Change appearance to card back for face-down cards
        M.stored_icon = M.icon       // Store original icon
        M.stored_icon_state = M.icon_state  // Store original icon state
        M.stored_name = M.name
        M.name = "Face-down Card"
        M.icon = 'playcard.dmi'      // Change to card back
        M.icon_state = "playcard_back"
    
    // Apply the final transform
    M.transform = transform_matrix
    
    // Update hand display after removal
    update_hand_display()

/mob/proc/spell_set(obj/card/spell/S)
    if(!S || !(S in hand))
        src << "That card is not in your hand!"
        return
    
    // Find all unoccupied spell/trap zones owned by the player
    var/list/available_zones = list()
    for(var/obj/duel/zone/spell_trap/Z in world)
        if(Z.owner == src && !Z.occupying_card)
            available_zones["Zone [Z.zone_id]"] = Z
        
    if(!available_zones.len)
        src << "No available Spell/Trap zones!"
        return
    
    // Let the player choose a zone
    var/choice = input(src, "Select a Spell/Trap zone:", "Set") as null|anything in available_zones
    if(!choice)
        return
    
    var/obj/duel/zone/spell_trap/selected_zone = available_zones[choice]
    
    // Complete the summoning
    set_spell_on_zone(S, selected_zone)
    
    src << "You set [S.name]!"


/mob/proc/set_spell_on_zone(obj/card/spell/S, obj/duel/zone/spell_trap/Z)
    // Remove from hand
    hand -= S
    
    // Update card and zone references
    S.current_zone = Z
    S.location = "field"
    Z.occupying_card = S

    // Set position and update visuals
    S.face_state = "down"
    S.stored_icon = S.icon
    S.stored_icon_state = S.icon_state
    S.stored_name = S.name
    S.name = "Face-down Card"
    S.icon = 'playcard.dmi'
    S.icon_state = "playcard_back"

    // Move the card to the zone's position
    S.loc = Z.loc

    // Create a new transform matrix starting with the zone's current transform. This preserves the field rotation inherited from the Zone.
    var/matrix/transform_matrix = Z.transform
    S.transform = transform_matrix

    // Update hand display after removal
    update_hand_display()


/mob/proc/trap_set(obj/card/trap/T)
    if(!T || !(T in hand))
        src << "That card is not in your hand!"
        return
    
    // Find all unoccupied spell/trap zones owned by the player
    var/list/available_zones = list()
    for(var/obj/duel/zone/spell_trap/Z in world)
        if(Z.owner == src && !Z.occupying_card)
            available_zones["Zone [Z.zone_id]"] = Z
        
    if(!available_zones.len)
        src << "No available Spell/Trap zones!"
        return
    
    // Let the player choose a zone
    var/choice = input(src, "Select a Spell/Trap zone:", "Set") as null|anything in available_zones
    if(!choice)
        return
    
    var/obj/duel/zone/spell_trap/selected_zone = available_zones[choice]
    
    // Complete the summoning
    set_spell_on_zone(T, selected_zone)
    
    src << "You set [T.name]!"


/mob/proc/set_trap_on_zone(obj/card/trap/T, obj/duel/zone/spell_trap/Z)
    // Remove from hand
    hand -= T
    
    // Update card and zone references
    T.current_zone = Z
    T.location = "field"
    Z.occupying_card = T

    // Set position and update visuals
    T.face_state = "down"
    T.stored_icon = T.icon
    T.stored_icon_state = T.icon_state
    T.stored_name = T.name
    T.name = "Face-down Card"
    T.icon = 'playcard.dmi'
    T.icon_state = "playcard_back"

    // Move the card to the zone's position
    T.loc = Z.loc

    // Create a new transform matrix starting with the zone's current transform. This preserves the field rotation inherited from the Zone.
    var/matrix/transform_matrix = Z.transform
    T.transform = transform_matrix

    // Update hand display after removal
    update_hand_display()


/obj/card/Click() //System for handling clicking cards depending where they are. If a card is set face down on the field and not owned by the player, simply add a return statement. If the card is owned by the player, list all available options.
    ..()
    if(usr != owner)
        return
    
    // Create a list of available actions based on card location
    var/list/actions = list()
    
    // Always add Show Preview
    actions["Show Preview"] = "preview"
    
    // Add location-specific actions
    switch(location)
        if("hand")
            if(istype(src, /obj/card/monster))
                actions["Normal Summon"] = "summon"
            if(istype(src, /obj/card/spell))
                actions["Set Spell"] = "set spell"
            if(istype(src, /obj/card/trap))
                actions["Set Trap"] = "set trap"
        if("field")
            usr <<output("current location is [src.location]")
    
    // Add Cancel option
    actions["Cancel"] = "cancel"
    
    // Show the list of options
    var/choice = input(usr, "What would you like to do with this card?", "Card Actions") as null|anything in actions
    if(!choice || choice == "Cancel")
        return
    
    // Process the chosen action
    switch(actions[choice])
        if("preview")
            show_preview()
        if("summon")
            usr.normal_summon(src)
        if("set spell")
            usr.spell_set(src)
        if("set trap")
            usr.trap_set(src)