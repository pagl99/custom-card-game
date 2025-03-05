/mob/    // Display stats in the stat panel
    Stat()
        statpanel("[name]")
        
        // Resource stats shown as percentages
        var/list/percent_stats = list("Health", "Energy", "Mana", "Willpower")
        for(var/stat_name in percent_stats)
            var/datum/stat/S = stats[stat_name]
            if(S) stat("[S.name]: ", "[S.to_percent()]%")
        
        // Combat/attribute stats shown as current/base
        var/list/base_stats = list("Strength", "Durability", "Reflex", "Speed", 
                                 "MagicPower", "MagicResistance", 
                                 "SpiritualForce", "SpiritualDefence",
                                 "MentalPower", "MentalResistance", 
                                 "Intelligence")
        for(var/stat_name in base_stats)
            var/datum/stat/S = stats[stat_name]
            if(S) stat("[S.name]: ", S.to_text())
            
        // Perks panel
        statpanel("Perks")
        for(var/obj/Perk/PERK in usr.perkInventory)
            stat(PERK)