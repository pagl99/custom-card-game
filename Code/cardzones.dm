/obj/duel/zone
    icon = 'cardzone.dmi'  // You'll need to create this icon file
    icon_state = "card_zone"
    density = 0  // So players can walk over it
    var/zone_id
    var/owner
    var/occupying_card

/obj/duel/zone/spell_trap
    icon_state = "card_zone"

/obj/duel/zone/monster
    icon_state = "card_zone"

/obj/duel/zone/graveyard
    icon_state = "graveyard"

/obj/duel/zone/banished
    icon_state = "banished"

/obj/duel/zone/extra
    icon_state = "card_zone"


/obj/duel/zone/deck
    icon = 'deck.dmi'
    icon_state = "deck_ns"
    var/datum/duel_deck/linked_deck
    
    Click()
        ..()
        if(!usr || usr != owner)
            return
            
        // Check if the player who clicked is the owner
        if(owner == usr && linked_deck && linked_deck.cards.len > 0)
            usr.draw_card()
        else
            usr << "No cards left in deck!"
            
    // Update appearance based on whether there are cards or not
    proc/update_appearance()
        if(linked_deck && linked_deck.cards.len > 0)
            icon_state = "deck_ns"
            name = "Deck ([linked_deck.cards.len])"
        else
            icon_state = "empty"
            name = "Deck (empty)"


/mob/proc/clear_duel_field()
    for(var/obj/duel/zone/Z in world)  // In a larger game you'd want to limit this search
        if (Z.owner == usr)
            del(Z)
    for(var/obj/card/C in world)
        if (C.owner == usr)
            del(C)



/mob/proc/create_duel_field()
    world << "Creating duel field..."
    
    // Get player's current position directly from coordinates
    var/player_x = src.x
    var/player_y = src.y
    var/player_z = src.z
    
    // Calculate front offsets based on direction
    var/front_x = player_x
    var/front_y = player_y
    var/far_front_x = player_x
    var/far_front_y = player_y
    
    // Create rotation matrix based on direction
    var/matrix/M = matrix()
    var/rotation_angle
    
    // Determine rotation angle based on direction
    switch(src.dir)
        if(NORTH)
            rotation_angle = 0  // Default orientation
        if(SOUTH)
            rotation_angle = 180
        if(EAST)
            rotation_angle = 90
        if(WEST)
            rotation_angle = 270
    
    // Set the rotation
    M.Turn(rotation_angle)
    
    // Adjust coordinates based on direction
    switch(src.dir)
        if(NORTH)
            front_y++
            far_front_y += 3
            
            // Generate spell/trap zones (front row)
            for(var/i in 1 to 5)
                var/x_offset = 3 - i
                var/final_x = front_x + x_offset
                var/turf/T = locate(final_x, front_y, player_z)
                if(T)
                    var/obj/duel/zone/spell_trap/ST = new()
                    ST.loc = T
                    ST.transform = M
                    ST.zone_id = "Spell/Trap [i]"
                    ST.owner = usr
                    world << "Created spell/trap zone at ([ST.x],[ST.y],[ST.z])"
            
            // Generate monster zones (far front row)
            for(var/i in 1 to 5)
                var/x_offset = 3 - i
                var/final_x = far_front_x + x_offset
                var/turf/T = locate(final_x, far_front_y, player_z)
                if(T)
                    var/obj/duel/zone/monster/MZ = new()
                    MZ.loc = T
                    MZ.transform = M
                    MZ.zone_id = "Monster Zone [i]"
                    world << "Created monster zone at ([MZ.x],[MZ.y],[MZ.z])"
                    MZ.owner = usr
            
            var/extra_deck_x = player_x - 3
            var/extra_deck_y = front_y
            var/turf/ExtraDeckTurf = locate(extra_deck_x, extra_deck_y, player_z)
            if(ExtraDeckTurf)
                var/obj/duel/zone/extra/ED = new()
                ED.loc = ExtraDeckTurf
                ED.transform = M 
                ED.zone_id = "Extra Deck"
                ED.name = "Extra Deck"
                world << "Created Extra Deck at ([ED.x],[ED.y],[ED.z])"
                ED.owner = usr

            var/graveyard_x = player_x + 3
            var/graveyard_y = far_front_y
            var/turf/GraveyardTurf = locate(graveyard_x, graveyard_y, player_z)
            if(GraveyardTurf)
                var/obj/duel/zone/graveyard/GY = new()
                GY.loc = GraveyardTurf
                GY.transform = M 
                GY.zone_id = "Graveyard"
                GY.name = "Graveyard"
                world << "Created Graveyard at ([GY.x],[GY.y],[GY.z])"
                GY.owner = usr

            var/banished_x = player_x + 4
            var/banished_y = far_front_y
            var/turf/BanishedTurf = locate(banished_x, banished_y, player_z)
            if(BanishedTurf)
                var/obj/duel/zone/banished/B = new()
                B.loc = BanishedTurf
                B.transform = M 
                B.zone_id = "Banished"
                B.name = "Banished"
                world << "Created Banished Zone at ([B.x],[B.y],[B.z])"
                B.owner = usr

            var/deck_x = player_x + 3  // Adjust as needed for your layout
            var/deck_y = front_y
            var/turf/DeckTurf = locate(deck_x, deck_y, player_z)
            if(DeckTurf)
                var/obj/duel/zone/deck/DZ = new()
                DZ.loc = DeckTurf
                DZ.transform = M
                DZ.zone_id = "Deck"
                DZ.name = "Deck"
                DZ.owner = usr
                world << "Created Deck Zone at ([DZ.x],[DZ.y],[DZ.z])"
                
                // Link the physical zone to the deck
                if(usr.duel_main_deck)
                    usr.duel_main_deck.link_to_zone(DZ)

        if(SOUTH)
            front_y--
            far_front_y -= 3
            
            // Generate spell/trap zones (front row)
            for(var/i in 1 to 5)
                var/x_offset = 3 - i
                var/final_x = front_x + x_offset
                var/turf/T = locate(final_x, front_y, player_z)
                if(T)
                    var/obj/duel/zone/spell_trap/ST = new()
                    ST.loc = T
                    ST.transform = M
                    ST.zone_id = "Spell/Trap [i]"
                    world << "Created spell/trap zone at ([ST.x],[ST.y],[ST.z])"
                    ST.owner = usr
            
            // Generate monster zones (far front row)
            for(var/i in 1 to 5)
                var/x_offset = 3 - i
                var/final_x = far_front_x + x_offset
                var/turf/T = locate(final_x, far_front_y, player_z)
                if(T)
                    var/obj/duel/zone/monster/MZ = new()
                    MZ.loc = T
                    MZ.transform = M
                    MZ.zone_id = "Monster Zone [i]"
                    world << "Created monster zone at ([MZ.x],[MZ.y],[MZ.z])"
                    MZ.owner = usr

        if(EAST)
            front_x++
            far_front_x += 3
            
            // Generate spell/trap zones (front row)
            for(var/i in 1 to 5)
                var/y_offset = 3 - i
                var/final_y = front_y + y_offset
                var/turf/T = locate(front_x, final_y, player_z)
                if(T)
                    var/obj/duel/zone/spell_trap/ST = new()
                    ST.loc = T
                    ST.transform = M
                    ST.zone_id = "Spell/Trap [i]"
                    world << "Created spell/trap zone at ([ST.x],[ST.y],[ST.z])"
                    ST.owner = usr
            
            // Generate monster zones (far front row)
            for(var/i in 1 to 5)
                var/y_offset = 3 - i
                var/final_y = far_front_y + y_offset
                var/turf/T = locate(far_front_x, final_y, player_z)
                if(T)
                    var/obj/duel/zone/monster/MZ = new()
                    MZ.loc = T
                    MZ.transform = M
                    MZ.zone_id = "Monster Zone [i]"
                    world << "Created monster zone at ([MZ.x],[MZ.y],[MZ.z])"
                    MZ.owner = usr

        if(WEST)
            front_x--
            far_front_x -= 3
            
            // Generate spell/trap zones (front row)
            for(var/i in 1 to 5)
                var/y_offset = 3 - i
                var/final_y = front_y + y_offset
                var/turf/T = locate(front_x, final_y, player_z)
                if(T)
                    var/obj/duel/zone/spell_trap/ST = new()
                    ST.loc = T
                    ST.transform = M
                    ST.zone_id = "Spell/Trap [i]"
                    world << "Created spell/trap zone at ([ST.x],[ST.y],[ST.z])"
                    ST.owner = usr
            
            // Generate monster zones (far front row)
            for(var/i in 1 to 5)
                var/y_offset = 3 - i
                var/final_y = far_front_y + y_offset
                var/turf/T = locate(far_front_x, final_y, player_z)
                if(T)
                    var/obj/duel/zone/monster/MZ = new()
                    MZ.loc = T
                    MZ.transform = M
                    MZ.zone_id = "Monster Zone [i]"
                    world << "Created monster zone at ([MZ.x],[MZ.y],[MZ.z])"
                    MZ.owner = usr