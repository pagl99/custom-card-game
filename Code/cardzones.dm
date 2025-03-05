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