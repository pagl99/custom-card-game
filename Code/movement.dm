// Constants for movement
#define TILE_SIZE 32
#define MOVEMENT_TIME 0.1  // Reduced to 0.2 seconds per tile

mob
    var
        moving = FALSE
    
    Move(newloc)
        if(moving)
            return FALSE
        
        var/move_dir = get_dir(src, newloc)
        var/turf/destination = get_step(src, move_dir)
        if(!destination || !can_move_to(destination))
            return FALSE
            
        // Update direction and start movement
        dir = move_dir
        moving = TRUE
        
        // Calculate exact glide speed for smooth movement
        glide_size = TILE_SIZE / (MOVEMENT_TIME * world.fps)
        animate_movement = SLIDE_STEPS
        
        // Move to destination
        loc = destination
        
        // Allow next movement after current one completes
        spawn(MOVEMENT_TIME * 10)
            moving = FALSE
        
        return TRUE
    
    proc
        can_move_to(turf/destination)
            return isturf(destination) && !destination.density

// Example usage
obj/player
    New()
        ..()
        bound_x = TILE_SIZE
        bound_y = TILE_SIZE