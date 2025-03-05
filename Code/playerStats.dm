mob
	var
		Perk_Points = 0
		Ability_Points = 0


stat
	var/activeStat = 0
	var/baseStat = 0

	New(n)
		if(n)
			activeStat = n
			baseStat = n

	proc/AddBaseStat(n)
		activeStat += n 
		baseStat += n

	proc/ToText()
		return "[activeStat]/[baseStat]"

	proc/ToPercent()
		return "[round(100*activeStat/baseStat)]"


mob
	var/stat/Health
	var/stat/Energy
	var/stat/Mana
	var/stat/Willpower
	var/stat/strength
	var/stat/durability
	var/stat/attackspeed
	var/stat/reflex
	var/stat/speed
	var/stat/magicpower
	var/stat/magicresistance
	var/stat/spiritualforce
	var/stat/spiritualdefence
	var/stat/mentalpower
	var/stat/mentalresistance
	var/stat/intelligence

	New()
		..()
	Health = new(100)
	Energy = new(1000)
	Mana = new(1000)
	Willpower = new (100)
	strength = new(5)
	attackspeed = new(5)
	reflex = new (5)
	durability = new(5)
	speed = new(5)
	magicpower = new(5)
	magicresistance = new (5)
	spiritualforce = new(5)
	spiritualdefence = new(5)
	mentalpower = new(5)
	mentalresistance = new(5)
	intelligence=new(5)

mob/verb/Stat_Set()
	for (var/obj/Perk/PERK in usr.perkInventory)
		strength.AddBaseStat(PERK.giveStrength)



mob/verb/Debuff_Stat()
	var/list/stats = list ("Strength","Attack Speed","Reflex", "Durability", "Speed", "Magic Power", "Magic Resistance", "Spiritual Force", "Spiritual Defence", "Mental Power", "Mental Resistance", "Intelligence")
	var/selected_stat = input("Which stat do you wish to debuff?") in stats 
	var/debuff = input("How much do you want to debuff your stat by?") as num
	switch(selected_stat)
		if("Strength")
			usr.strength.activeStat -= debuff
		if("Attack Speed")
			usr.strength.activeStat -= debuff	
		if("Reflex")
			usr.reflex.activeStat -= debuff
		if("Durability")
			usr.durability.activeStat -= debuff
		if("Speed")
			usr.speed.activeStat -= debuff
		if("Magic Power")
			usr.magicpower.activeStat -= debuff
		if("Magic Resistance")
			usr.magicresistance.activeStat -= debuff													
	usr << output ("Your [selected_stat] has decreased by -[debuff] points!")
