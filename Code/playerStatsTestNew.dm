// Stat datum with only temporary modifications allowed
/datum/stat
    var/activeStat = 0
    var/baseStat = 0
    var/name

    New(initial_value, stat_name)
        baseStat = initial_value
        activeStat = initial_value
        name = stat_name

    // Only allow modifying the active stat
    proc/modify(amount)
        activeStat = activeStat + amount
        if(activeStat < 0) activeStat = 0
        return src

    // Reset stat to base value
    proc/reset()
        activeStat = baseStat
        return src

    proc/to_text()
        var/active_text = "[activeStat]"
        if(activeStat < baseStat)
            active_text = "[activeStat]"
        else if(activeStat > baseStat)
            active_text = "[activeStat]"
        return "[active_text]/[baseStat]"

    proc/to_percent()
        return "[round(100 * activeStat/baseStat)]"

// Global list of stat definitions with their base values
var/global/list/STAT_DEFINITIONS = list(
    "Health" = list(100, "Health"),
    "Energy" = list(1000, "Energy"),
    "Mana" = list(1000, "Mana"),
    "Willpower" = list(100, "Willpower"),
    "Strength" = list(5, "Strength"),
    "Durability" = list(5, "Durability"),
    "AttackSpeed" = list(5, "Attack Speed"),
    "Reflex" = list(5, "Reflex"),
    "Speed" = list(5, "Speed"),
    "MagicPower" = list(5, "Magic Power"),
    "MagicResistance" = list(5, "Magic Resistance"),
    "SpiritualForce" = list(5, "Spiritual Force"),
    "SpiritualDefence" = list(5, "Spiritual Defence"),
    "MentalPower" = list(5, "Mental Power"),
    "MentalResistance" = list(5, "Mental Resistance"),
    "Intelligence" = list(5, "Intelligence")
)

/mob
    var/list/stats = list()

    New()
        ..()
        initialize_stats()

    proc/initialize_stats()
        for(var/stat_key in STAT_DEFINITIONS)
            var/list/stat_info = STAT_DEFINITIONS[stat_key]
            stats[stat_key] = new /datum/stat(stat_info[1], stat_info[2])

    proc/get_stat(stat_name)
        return stats[stat_name]

    // Modified to only handle temporary changes
    proc/modify_stat(stat_name, amount)
        var/datum/stat/S = get_stat(stat_name)
        if(S)
            S.modify(amount)
            return TRUE
        return FALSE

    // Added ability to reset a specific stat
    proc/reset_stat(stat_name)
        var/datum/stat/S = get_stat(stat_name)
        if(S)
            S.reset()
            return TRUE
        return FALSE

    // Added ability to reset all stats
    proc/reset_all_stats()
        for(var/stat_name in stats)
            reset_stat(stat_name)

    // Display stats in the stat panel
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

// Verb for modifying stats (temporary only)
/mob/verb/modify_stat_value()
    set name = "Modify Stat"
    
    var/list/stat_choices = list()
    for(var/stat_key in stats)
        var/datum/stat/S = stats[stat_key]
        stat_choices += S.name

    var/selected_stat_name = input("Choose stat to modify:", "Modify Stat") as null|anything in stat_choices
    if(!selected_stat_name)
        return

    var/modification = input("Enter modification amount (negative for decrease):", "Modify Stat") as num
    if(!modification)
        return
    
    for(var/stat_key in stats)
        var/datum/stat/S = stats[stat_key]
        if(S.name == selected_stat_name)
            modify_stat(stat_key, modification)
            usr << "Modified [S.name] by [modification] points"
            break

// Verb for resetting stats
/mob/verb/reset_modified_stats()
    set name = "Reset Stats"
    
    var/choice = alert("Reset all stats or choose one?", "Reset Stats", "All", "Choose One", "Cancel")
    switch(choice)
        if("All")
            reset_all_stats()
            usr << "All stats reset to base values"
        if("Choose One")
            var/list/stat_choices = list()
            for(var/stat_key in stats)
                var/datum/stat/S = stats[stat_key]
                stat_choices += S.name
            
            var/selected_stat_name = input("Choose stat to reset:", "Reset Stat") as null|anything in stat_choices
            if(!selected_stat_name)
                return
                
            for(var/stat_key in stats)
                var/datum/stat/S = stats[stat_key]
                if(S.name == selected_stat_name)
                    reset_stat(stat_key)
                    usr << "[S.name] reset to base value"
                    break