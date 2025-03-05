//Create an interface for the user to select Race/Hair/Base Icon/Name/Sex
//Begin by rolling genes for the user. 

mob 
	var 
		canSay = 0
		saveable = 0
		canMove = 1
		list/inventory = list()
		list/perkInventory = list()
		list/geneInventory = list()
		list/techniqueInventory = list()
		characterGender = "male"
		race = "human"
		skintone = "pale"
		subrace=""
		obj/previewMob = new
		hair = null
	
mob/proc/StartCreation()
	set hidden = 1
	usr.icon = 'Human Male - Pale.dmi'
	usr.previewMob.appearance = usr.appearance
	winset(src,"World","is-default=false")
	winset(src,"creationPreview","is-default=true")
	winset(usr,"creationPreview","zoom=5;zoom-mode=normal")	
	usr.client.eye = locate(8,8,1)
	previewMob.screen_loc = "CENTER,CENTER"
	client.screen += previewMob
	MaleHumanButtonPressed()
	MaleGenderButtonPressed()
	ShowStaticButtons()

mob/proc/UpdatePreviewAppearance()
	usr.previewMob.appearance = usr.appearance		

mob/proc/SetRaceOffset(race)
	if (race == "human")
		previewMob.screen_loc = "CENTER,CENTER"
	if (race == "orc")
		previewMob.screen_loc = "CENTER:-3,CENTER:-3"
	if (race == "elf")
		previewMob.screen_loc = "CENTER:-5,CENTER:-5"
	if (race == "varkarian")
		previewMob.screen_loc = "CENTER:-9,CENTER:-9"


mob/verb/SetGenderFemale()
	set hidden = 1
	usr.characterGender = "female"
	FemaleGenderButtonPressed()
	if (usr.race == "human")
		usr.icon = 'Human Female - Pale.dmi'
		FemaleHumanButtonPressed()
	if (usr.race == "elf")
		usr.icon = 'Elf Female - Pale.dmi'
		FemaleElfButtonPressed()
	if (usr.race == "orc")
		usr.icon = 'Orc Female - Grey.dmi'
		FemaleOrcButtonPressed()
	if (usr.race== "varkarian")
		usr.icon = 'Varkarian Female - Pale.dmi'
		FemaleVarkButtonPressed()
	UpdatePreviewAppearance()

mob/verb/SetGenderMale()
	set hidden = 1
	usr.characterGender = "male"
	MaleGenderButtonPressed()
	if (usr.race == "human")
		usr.icon = 'Human Male - Pale.dmi'
		MaleHumanButtonPressed()
	if (usr.race == "elf")
		usr.icon = 'Elf Male - Pale.dmi'
		MaleElfButtonPressed()
	if (usr.race == "orc")
		usr.icon = 'Orc Male - Grey.dmi'
		MaleOrcButtonPressed()
	if (usr.race== "varkarian")
		usr.icon = 'Varkarian Male - Pale.dmi'
		MaleVarkButtonPressed()
	UpdatePreviewAppearance()

mob/verb/SetRaceElf()
	set hidden = 1
	RemoveOverlays()
	usr.subrace = ""
	usr.race = "elf"
	if (usr.characterGender =="male")
		usr.icon = 'Elf Male - Pale.dmi'
		MaleElfButtonPressed()
	if (usr.characterGender =="female")
		FemaleElfButtonPressed()
		usr.icon = 'Elf Female - Pale.dmi'
	UpdatePreviewAppearance()
	SetRaceOffset(usr.race)
	
mob/verb/SetRaceHuman()
	set hidden = 1
	RemoveOverlays()
	usr.subrace = ""
	usr.race = "human"
	if (usr.characterGender =="male")
		MaleHumanButtonPressed()
		usr.icon = 'Human Male - Pale.dmi'
	if (usr.characterGender =="female")
		FemaleHumanButtonPressed()
		usr.icon = 'Human Female - Pale.dmi'
	SetRaceOffset(usr.race)
	UpdatePreviewAppearance()


mob/verb/SetRaceOrc()
	set hidden = 1
	RemoveOverlays()
	usr.subrace = ""
	usr.race = "orc"
	if (usr.characterGender =="male")
		MaleOrcButtonPressed()
		usr.icon = 'Orc Male - Grey.dmi'
	if (usr.characterGender =="female")
		FemaleOrcButtonPressed()
		usr.icon = 'Orc Female - Grey.dmi'
	SetRaceOffset(usr.race)
	UpdatePreviewAppearance()

mob/verb/SetRaceVark()
	set hidden = 1
	RemoveOverlays()
	previewMob.screen_loc = "CENTER:-9,CENTER:-9"
	usr.subrace = ""
	usr.race = "varkarian"
	if (usr.characterGender =="male")
		MaleVarkButtonPressed()
		usr.icon = 'Varkarian Male - Pale.dmi'
	if (usr.characterGender =="female")
		FemaleVarkButtonPressed()
		usr.icon = 'Varkarian Female - Pale.dmi'
	SetRaceOffset(usr.race)
	UpdatePreviewAppearance()


mob/verb/SetBase()
	set hidden = 1
	if (usr.race == "orc")
		switch(input("Select your base icon from the following list:") in list ("Brown","Green","Grey","Red"))
			if("Brown")
				if (usr.characterGender == "male")
					usr.icon = 'Orc Male - Brown.dmi'
				if (usr.characterGender == "female")
					usr.icon = 'Orc Female - Brown.dmi'
			if("Green")
				if (usr.characterGender == "male")
					usr.icon = 'Orc Male - Green.dmi'
				if (usr.characterGender == "female")
					usr.icon = 'Orc Female - Green.dmi'
			if("Grey")
				if (usr.characterGender == "male")
					usr.icon = 'Orc Male - Grey.dmi'
				if (usr.characterGender == "female")
					usr.icon = 'Orc Female - Grey.dmi'
			if("Red")
				if (usr.characterGender == "male")
					usr.icon = 'Orc Male - Red.dmi'
				if (usr.characterGender == "female")
					usr.icon = 'Orc Female - Red.dmi'
		UpdatePreviewAppearance()
		return					
	switch(input("Select your base icon from the following list:") in list ("Pale","White","Tan","Brown","Dark"))
		if ("Pale")
			if (usr.race == "human" && usr.gender == "male")
				usr.icon = 'Human Male - Pale.dmi'
			if (usr.race == "elf" && usr.gender == "male")
				usr.icon = 'Elf Male - Pale.dmi'
			if (usr.race == "varkarian" && usr.gender == "male")
				usr.icon = 'Varkarian Male - Pale.dmi'
			if (usr.race == "human" && usr.gender == "female")
				usr.icon = 'Human Female - Pale.dmi'
			if (usr.race == "elf" && usr.gender == "female")
				usr.icon = 'Elf Female - Pale.dmi'
			if (usr.race == "varkarian" && usr.gender == "female")
				usr.icon = 'Varkarian Female - Pale.dmi'
		if ("White")
			if (usr.race == "human" && usr.gender == "male")
				usr.icon = 'Human Male - White.dmi'
			if (usr.race == "elf" && usr.gender == "male")
				usr.icon = 'Elf Male - White.dmi'
			if (usr.race == "varkarian" && usr.gender == "male")
				usr.icon = 'Varkarian Male - White.dmi'
			if (usr.race == "human" && usr.gender == "female")
				usr.icon = 'Human Female - White.dmi'
			if (usr.race == "elf" && usr.gender == "female")
				usr.icon = 'Elf Female - White.dmi'
			if (usr.race == "varkarian" && usr.gender == "female")
				usr.icon = 'Varkarian Female - White.dmi'
		if ("Tan")
			if (usr.race == "human" && usr.gender == "male")
				usr.icon = 'Human Male - Tan.dmi'
			if (usr.race == "elf" && usr.gender == "male")
				usr.icon = 'Elf Male - Tan.dmi'
			if (usr.race == "varkarian" && usr.gender == "male")
				usr.icon = 'Varkarian Male - Tan.dmi'
			if (usr.race == "human" && usr.gender == "female")
				usr.icon = 'Human Female - Tan.dmi'
			if (usr.race == "elf" && usr.gender == "female")
				usr.icon = 'Elf Female - Tan.dmi'
			if (usr.race == "varkarian" && usr.gender == "female")
				usr.icon = 'Varkarian Female - Tan.dmi'
		if ("Brown")
			if (usr.race == "human" && usr.gender == "male")
				usr.icon = 'Human Male - Brown.dmi'
			if (usr.race == "elf" && usr.gender == "male")
				usr.icon = 'Elf Male - Brown.dmi'
			if (usr.race == "varkarian" && usr.gender == "male")
				usr.icon = 'Varkarian Male - Brown.dmi'
			if (usr.race == "human" && usr.gender == "female")
				usr.icon = 'Human Female - Brown.dmi'
			if (usr.race == "elf" && usr.gender == "female")
				usr.icon = 'Elf Female - Brown.dmi'
			if (usr.race == "varkarian" && usr.gender == "female")
				usr.icon = 'Varkarian Female - Brown.dmi'
		if ("Dark")
			if (usr.race == "human" && usr.gender == "male")
				usr.icon = 'Human Male - Dark.dmi'
			if (usr.race == "elf" && usr.gender == "male")
				usr.icon = 'Elf Male - Dark.dmi'
			if (usr.race == "varkarian" && usr.gender == "male")
				usr.icon = 'Varkarian Male - Dark.dmi'
			if (usr.race == "human" && usr.gender == "female")
				usr.icon = 'Human Female - Dark.dmi'
			if (usr.race == "elf" && usr.gender == "female")
				usr.icon = 'Elf Female - Dark.dmi'
			if (usr.race == "varkarian" && usr.gender == "female")
				usr.icon = 'Varkarian Female - Dark.dmi'												
	UpdatePreviewAppearance()	


mob/verb/SelectHair()
	set hidden = 1
	var/currentRace = usr.race
	usr.overlays -= hair
	usr.hair = null
	if (usr.race == "human")
		switch(input("Select your Hair from the following list:") in list ("Bald","Long","Rebel"))
			if ("Bald")
				usr.hair = null
			if ("Long")
				usr.hair = 'Human - Long Hair 1.dmi'
			if ("Rebel")
				usr.hair = 'Human - Short Rebel Hair.dmi'
	if (usr.race == "elf")
		switch(input("Select your Hair from the following list:") in list ("Bald","Long","Rebel"))
			if ("Bald")
				usr.hair = null
			if ("Long")
				usr.hair = 'Elf - Long Hair 1.dmi'
			if ("Rebel")
				usr.hair = 'Elf - Short Rebel Hair.dmi'
	if (usr.race == "orc")
		switch(input("Select your Hair from the following list:") in list ("Bald","Long","Rebel"))
			if ("Bald")
				usr.hair = null
			if ("Long")
				usr.hair = 'Orc - Long Hair 1.dmi'
			if ("Rebel")
				usr.hair = 'Orc - Short Rebel Hair.dmi'
	if (usr.race == "varkarian")
		switch(input("Select your Hair from the following list:") in list ("Bald","Long","Rebel"))
			if ("Bald")
				usr.hair = null
			if ("Long")
				usr.hair = 'Vark - Long Hair 1.dmi'
			if ("Rebel")
				usr.hair = 'Vark - Short Rebel Hair.dmi'
	if (usr.hair && currentRace == usr.race)
		hair+= input("Select your Hair color") as color
		overlays+=hair
	UpdatePreviewAppearance()
 


mob/proc/RemoveOverlays()
	usr.overlays -= hair
	usr.hair = null




mob/proc/NameCheck(name)
	if (name == "" || findtext(name, "/n"|| subrace==""))
		return 0
	return 1


mob/verb/FinishCreation()
	set hidden = 1
	var/charName = winget(usr,"characterNameInput", "text")
	if (!NameCheck(charName))
		usr << output("Name cannot be blank or contain invalid characters!")
		return
	usr.name = charName
	usr.loc=locate(1,5,1)
	winshow(usr,"characterCreationMain",0)
	winset(usr,null,"creationPreview.is-default=false;map.is-default=true;map.is-visible=true")
	usr.canMove = 1
	usr.canSay = 1
	usr.client.eye = usr
	usr.saveable = 1
	Save()
	client.screen -= previewMob