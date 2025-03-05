/datum/perk_tier
	var/name
	var/description
	var/list/stat_bonuses = list()

	New(tier_name, tier_desc, list/bonuses)
		name = tier_name
		description = tier_desc
		stat_bonuses = bonuses

/obj/Perk
	var/list/tiers = list()    // List of perk_tier datums
	var/current_tier = 1
	var/max_tier = 1
	icon = null
	icon_state = null
	
	proc/setup_tiers(list/tier_data)
		for(var/tier_num in tier_data)
			var/list/data = tier_data[tier_num]
			tiers += new /datum/perk_tier(data["name"], data["desc"], data["stats"])
			max_tier = max(max_tier, text2num(tier_num))

	proc/can_upgrade()
		return current_tier < max_tier

	proc/upgrade(mob/M)
		if(can_upgrade())
			// Remove old tier stats
			var/datum/perk_tier/old_tier = get_current_tier()
			for(var/stat_name in old_tier.stat_bonuses)
				var/datum/stat/S = M.stats[stat_name]
				if(S) S.baseStat -= old_tier.stat_bonuses[stat_name]
			
			// Apply new tier stats
			current_tier++
			var/datum/perk_tier/new_tier = get_current_tier()
			for(var/stat_name in new_tier.stat_bonuses)
				var/datum/stat/S = M.stats[stat_name]
				if(S) S.baseStat += new_tier.stat_bonuses[stat_name]
				
			// Update active stats to match new base stats
			for(var/stat_name in M.stats)
				var/datum/stat/S = M.stats[stat_name]
				S.activeStat = S.baseStat
				
			name = new_tier.name
			return TRUE
		return FALSE

	proc/get_current_tier()
		return tiers[current_tier]

	proc/apply_stats(mob/M)
		var/datum/perk_tier/T = get_current_tier()
		for(var/stat_name in T.stat_bonuses)
			var/datum/stat/S = M.stats[stat_name]
			if(S)
				S.baseStat += T.stat_bonuses[stat_name]
				S.activeStat = S.baseStat

	proc/remove_stats(mob/M)
		var/datum/perk_tier/T = get_current_tier()
		for(var/stat_name in T.stat_bonuses)
			var/datum/stat/S = M.stats[stat_name]
			if(S)
				S.baseStat -= T.stat_bonuses[stat_name]
				S.activeStat = S.baseStat

	Click()
		if(src in usr.perkInventory)
			var/datum/perk_tier/T = get_current_tier()
			viewers(16) << output("<font color=grey>[usr] just activated [name]: <font color=purple>[T.description] A Tier [current_tier] perk.","World.OOC")

		
// Example perk definition
/obj/Perk/NinjutsuDefense
	New()
		..()
		icon = 'Avatar Snow.dmi'
		icon_state = "Icehole"
		name = "Beginner Ninjutsu Defense" // Initial name
		
		var/list/tier_data = list(
			"1" = list(
				"name" = "Beginner Ninjutsu Defense",
				"desc" = "You've begun learning the art of defensive ninjutsu.",
				"stats" = list(
					"Strength" = 5,
					"Speed" = 3
				)
			),
			"2" = list(
				"name" = "Adept Ninjutsu Defense",
				"desc" = "Your defensive capabilities have grown significantly.",
				"stats" = list(
					"Strength" = 10,
					"Speed" = 6,
					"Reflex" = 5
				)
			),
			"3" = list(
				"name" = "Master Ninjutsu Defense",
				"desc" = "You've mastered defensive techniques.",
				"stats" = list(
					"Strength" = 15,
					"Speed" = 9,
					"Reflex" = 10,
					"Durability" = 8
				)
			)
		)
		setup_tiers(tier_data)

// Mob methods for perk management
/mob/verb/get_perk()
	var/obj/Perk/new_perk = new/obj/Perk/NinjutsuDefense
	if(locate(new_perk.type) in perkInventory)
		src << "You already have this perk!"
		del(new_perk)
		return
	
	perkInventory += new_perk
	new_perk.apply_stats(src)
	src << "You acquired [new_perk.name]!"

/mob/verb/upgrade_perk()
	var/list/upgradeable_perks = list()
	for(var/obj/Perk/P in perkInventory)
		if(P.can_upgrade())
			upgradeable_perks += P
	
	if(!length(upgradeable_perks))
		src << "You have no perks that can be upgraded!"
		return
	
	var/obj/Perk/selected = input("Choose a perk to upgrade:", "Upgrade Perk") as null|anything in upgradeable_perks
	if(!selected) return
	
	if(selected.upgrade(src))
		var/datum/perk_tier/T = selected.get_current_tier()
		src << "Successfully upgraded to [selected.name]!"
	else
		src << "Unable to upgrade perk further!"

// Additional proc to handle perk removal if needed
/mob/proc/remove_perk(obj/Perk/P)
	if(P in perkInventory)
		P.remove_stats(src)
		perkInventory -= P
		del(P)

// Modified Stat panel to show current perks with updated names
/mob/Stat()
	..()
	statpanel("Perks")
	for(var/obj/Perk/P in perkInventory)
		var/datum/perk_tier/T = P.get_current_tier()
		stat(P.name, T.description)



/obj/Perk/Custom
	New(perk_name, perk_desc, list/stat_values)
		..()
		icon = 'Avatar Snow.dmi'  // Default icon, can be changed
		icon_state = "Icehole"    // Default icon state
		name = perk_name         // Set the name property for the perk
		
		var/list/tier_data = list(
			"1" = list(
				"name" = perk_name,
				"desc" = perk_desc,
				"stats" = stat_values
			)
		)
		setup_tiers(tier_data)



/mob/verb/create_perk()
	set name = "Create Custom Perk"
	
	var/perk_name = input("Enter the perk name:", "Create Perk") as text
	if(!perk_name) return
	
	var/perk_desc = input("Enter the perk description:", "Create Perk") as text
	if(!perk_desc) return
	
	var/list/possible_stats = list(
		"Strength",
		"Durability",
		"AttackSpeed",
		"Reflex",
		"Speed",
		"MagicPower",
		"MagicResistance",
		"SpiritualForce",
		"SpiritualDefence",
		"MentalPower",
		"MentalResistance",
		"Intelligence"
	)
	
	var/list/stat_values = list()
	var/adding_stats = 1
	
	while(adding_stats)
		var/stat_choice = input("Select a stat to modify (Cancel to finish):", "Add Stat") as null|anything in possible_stats
		if(!stat_choice)
			adding_stats = 0
			continue
			
		var/stat_value = input("Enter the bonus value for [stat_choice]:", "Stat Value") as num
		if(stat_value)
			stat_values[stat_choice] = stat_value
			possible_stats -= stat_choice
		
		if(!length(possible_stats))
			adding_stats = 0
	
	if(!length(stat_values))
		usr << "No stats were specified. Canceling perk creation."
		return
	
	var/obj/Perk/new_perk = new/obj/Perk/Custom(perk_name, perk_desc, stat_values)
	
	// Preview the perk before adding it
	var/preview = {"
Perk Preview:
Name: [perk_name]
Description: [perk_desc]
Stats:"}
	
	for(var/stat in stat_values)
		preview += "\n[stat]: +[stat_values[stat]]"
	
	switch(alert(preview + "\n\nAdd this perk?", "Confirm Perk", "Yes", "No"))
		if("Yes")
			perkInventory += new_perk
			new_perk.apply_stats(src)
			src << "Created and applied new perk: [perk_name]"
		if("No")
			del(new_perk)
			src << "Cancelled perk creation."


/mob/verb/remove_perk_verb()
    set name = "Remove Perk"
    
    if(!length(perkInventory))
        src << "You have no perks to remove!"
        return
        
    var/obj/Perk/selected = input("Choose a perk to remove:", "Remove Perk") as null|anything in perkInventory
    if(!selected) return
    
    selected.remove_stats(src)  // Remove the stat bonuses
    perkInventory -= selected   // Remove from inventory
    src << "Removed [selected.name]"
    del(selected)               // Delete the perk object