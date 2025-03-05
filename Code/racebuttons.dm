mob/proc/RaceButtonIconsMale()
 
	var/icon/MaleElf = new('CharacterCreationUIRaceIcons.dmi', "MaleElf")
	var/MaleElfIcon = fcopy_rsc(MaleElf)
	winset(src, "race1Button", "image=\ref[MaleElfIcon]")
 
	var/icon/MaleHuman = new('CharacterCreationUIRaceIcons.dmi', "MaleHuman")
	var/MaleHumanIcon = fcopy_rsc(MaleHuman)
	winset(src, "race2Button", "image=\ref[MaleHumanIcon]")

	var/icon/MaleOrc = new('CharacterCreationUIRaceIcons.dmi', "MaleOrc")
	var/MaleOrcIcon = fcopy_rsc(MaleOrc)
	winset(src, "race3Button", "image=\ref[MaleOrcIcon]")

	var/icon/MaleVark = new('CharacterCreationUIRaceIcons.dmi', "MaleVark")
	var/MaleVarkIcon = fcopy_rsc(MaleVark)
	winset(src, "race4Button", "image=\ref[MaleVarkIcon]")


mob/proc/RaceButtonIconsFemale()
 
	var/icon/FemaleElf = new('CharacterCreationUIRaceIcons.dmi', "FemaleElf")
	var/FemaleElfIcon = fcopy_rsc(FemaleElf)
	winset(src, "race1Button", "image=\ref[FemaleElfIcon]")
 
	var/icon/FemaleHuman = new('CharacterCreationUIRaceIcons.dmi', "FemaleHuman")
	var/FemaleHumanIcon = fcopy_rsc(FemaleHuman)
	winset(src, "race2Button", "image=\ref[FemaleHumanIcon]")

	var/icon/FemaleOrc = new('CharacterCreationUIRaceIcons.dmi', "FemaleOrc")
	var/FemaleOrcIcon = fcopy_rsc(FemaleOrc)
	winset(src, "race3Button", "image=\ref[FemaleOrcIcon]")

	var/icon/FemaleVark = new('CharacterCreationUIRaceIcons.dmi', "FemaleVark")
	var/FemaleVarkIcon = fcopy_rsc(FemaleVark)
	winset(src, "race4Button", "image=\ref[FemaleVarkIcon]")


mob/proc/MaleHumanButtonPressed()
	var/icon/MaleHumanPressed = new('CharacterCreationUIRaceIcons.dmi', "MaleHumanPressed")
	var/MaleHumanPressedIcon = fcopy_rsc(MaleHumanPressed)
	winset(src, "race2Button", "image=\ref[MaleHumanPressedIcon]")

	var/icon/MaleElf = new('CharacterCreationUIRaceIcons.dmi', "MaleElf")
	var/MaleElfIcon = fcopy_rsc(MaleElf)
	winset(src, "race1Button", "image=\ref[MaleElfIcon]")

	var/icon/MaleOrc = new('CharacterCreationUIRaceIcons.dmi', "MaleOrc")
	var/MaleOrcIcon = fcopy_rsc(MaleOrc)
	winset(src, "race3Button", "image=\ref[MaleOrcIcon]")

	var/icon/MaleVark = new('CharacterCreationUIRaceIcons.dmi', "MaleVark")
	var/MaleVarkIcon = fcopy_rsc(MaleVark)
	winset(src, "race4Button", "image=\ref[MaleVarkIcon]")
 
mob/proc/MaleElfButtonPressed()
	var/icon/I = new('CharacterCreationUIRaceIcons.dmi', "MaleElfPressed")
	var/iconfile = fcopy_rsc(I)
	winset(src, "race1Button", "image=\ref[iconfile]")

	var/icon/MaleHuman = new('CharacterCreationUIRaceIcons.dmi', "MaleHuman")
	var/MaleHumanIcon = fcopy_rsc(MaleHuman)
	winset(src, "race2Button", "image=\ref[MaleHumanIcon]")

	var/icon/MaleOrc = new('CharacterCreationUIRaceIcons.dmi', "MaleOrc")
	var/MaleOrcIcon = fcopy_rsc(MaleOrc)
	winset(src, "race3Button", "image=\ref[MaleOrcIcon]")

	var/icon/MaleVark = new('CharacterCreationUIRaceIcons.dmi', "MaleVark")
	var/MaleVarkIcon = fcopy_rsc(MaleVark)
	winset(src, "race4Button", "image=\ref[MaleVarkIcon]")

mob/proc/MaleOrcButtonPressed()
	var/icon/I = new('CharacterCreationUIRaceIcons.dmi', "MaleOrcPressed")
	var/iconfile = fcopy_rsc(I)
	winset(src, "race3Button", "image=\ref[iconfile]")

	var/icon/MaleElf = new('CharacterCreationUIRaceIcons.dmi', "MaleElf")
	var/MaleElfIcon = fcopy_rsc(MaleElf)
	winset(src, "race1Button", "image=\ref[MaleElfIcon]")

	var/icon/MaleHuman = new('CharacterCreationUIRaceIcons.dmi', "MaleHuman")
	var/MaleHumanIcon = fcopy_rsc(MaleHuman)
	winset(src, "race2Button", "image=\ref[MaleHumanIcon]")

	var/icon/MaleVark = new('CharacterCreationUIRaceIcons.dmi', "MaleVark")
	var/MaleVarkIcon = fcopy_rsc(MaleVark)
	winset(src, "race4Button", "image=\ref[MaleVarkIcon]")

mob/proc/MaleVarkButtonPressed()
	var/icon/I = new('CharacterCreationUIRaceIcons.dmi', "MaleVarkPressed")
	var/iconfile = fcopy_rsc(I)
	winset(src, "race4Button", "image=\ref[iconfile]")

	var/icon/MaleElf = new('CharacterCreationUIRaceIcons.dmi', "MaleElf")
	var/MaleElfIcon = fcopy_rsc(MaleElf)
	winset(src, "race1Button", "image=\ref[MaleElfIcon]")

	var/icon/MaleHuman = new('CharacterCreationUIRaceIcons.dmi', "MaleHuman")
	var/MaleHumanIcon = fcopy_rsc(MaleHuman)
	winset(src, "race2Button", "image=\ref[MaleHumanIcon]")

	var/icon/MaleOrc = new('CharacterCreationUIRaceIcons.dmi', "MaleOrc")
	var/MaleOrcIcon = fcopy_rsc(MaleOrc)
	winset(src, "race3Button", "image=\ref[MaleOrcIcon]")

mob/proc/FemaleElfButtonPressed()
	var/icon/I = new('CharacterCreationUIRaceIcons.dmi', "FemaleElfPressed")
	var/iconfile = fcopy_rsc(I)
	winset(src, "race1Button", "image=\ref[iconfile]")
 
	var/icon/FemaleHuman = new('CharacterCreationUIRaceIcons.dmi', "FemaleHuman")
	var/FemaleHumanIcon = fcopy_rsc(FemaleHuman)
	winset(src, "race2Button", "image=\ref[FemaleHumanIcon]")

	var/icon/FemaleOrc = new('CharacterCreationUIRaceIcons.dmi', "FemaleOrc")
	var/FemaleOrcIcon = fcopy_rsc(FemaleOrc)
	winset(src, "race3Button", "image=\ref[FemaleOrcIcon]")

	var/icon/FemaleVark = new('CharacterCreationUIRaceIcons.dmi', "FemaleVark")
	var/FemaleVarkIcon = fcopy_rsc(FemaleVark)
	winset(src, "race4Button", "image=\ref[FemaleVarkIcon]")


mob/proc/FemaleHumanButtonPressed()
	var/icon/I = new('CharacterCreationUIRaceIcons.dmi', "FemaleHumanPressed")
	var/iconfile = fcopy_rsc(I)
	winset(src, "race2Button", "image=\ref[iconfile]")
 
	var/icon/FemaleElf = new('CharacterCreationUIRaceIcons.dmi', "FemaleElf")
	var/FemaleElfIcon = fcopy_rsc(FemaleElf)
	winset(src, "race1Button", "image=\ref[FemaleElfIcon]")

	var/icon/FemaleOrc = new('CharacterCreationUIRaceIcons.dmi', "FemaleOrc")
	var/FemaleOrcIcon = fcopy_rsc(FemaleOrc)
	winset(src, "race3Button", "image=\ref[FemaleOrcIcon]")

	var/icon/FemaleVark = new('CharacterCreationUIRaceIcons.dmi', "FemaleVark")
	var/FemaleVarkIcon = fcopy_rsc(FemaleVark)
	winset(src, "race4Button", "image=\ref[FemaleVarkIcon]")

mob/proc/FemaleOrcButtonPressed()
	var/icon/I = new('CharacterCreationUIRaceIcons.dmi', "FemaleOrcPressed")
	var/iconfile = fcopy_rsc(I)
	winset(src, "race3Button", "image=\ref[iconfile]")
 
	var/icon/FemaleElf = new('CharacterCreationUIRaceIcons.dmi', "FemaleElf")
	var/FemaleElfIcon = fcopy_rsc(FemaleElf)
	winset(src, "race1Button", "image=\ref[FemaleElfIcon]")

	var/icon/FemaleHuman = new('CharacterCreationUIRaceIcons.dmi', "FemaleHuman")
	var/FemaleHumanIcon = fcopy_rsc(FemaleHuman)
	winset(src, "race2Button", "image=\ref[FemaleHumanIcon]")

	var/icon/FemaleVark = new('CharacterCreationUIRaceIcons.dmi', "FemaleVark")
	var/FemaleVarkIcon = fcopy_rsc(FemaleVark)
	winset(src, "race4Button", "image=\ref[FemaleVarkIcon]")

mob/proc/FemaleVarkButtonPressed()
	var/icon/I = new('CharacterCreationUIRaceIcons.dmi', "FemaleVarkPressed")
	var/iconfile = fcopy_rsc(I)
	winset(src, "race4Button", "image=\ref[iconfile]")
 
	var/icon/FemaleElf = new('CharacterCreationUIRaceIcons.dmi', "FemaleElf")
	var/FemaleElfIcon = fcopy_rsc(FemaleElf)
	winset(src, "race1Button", "image=\ref[FemaleElfIcon]")

	var/icon/FemaleHuman = new('CharacterCreationUIRaceIcons.dmi', "FemaleHuman")
	var/FemaleHumanIcon = fcopy_rsc(FemaleHuman)
	winset(src, "race2Button", "image=\ref[FemaleHumanIcon]")

	var/icon/FemaleOrc = new('CharacterCreationUIRaceIcons.dmi', "FemaleOrc")
	var/FemaleOrcIcon = fcopy_rsc(FemaleOrc)
	winset(src, "race3Button", "image=\ref[FemaleOrcIcon]")


mob/proc/MaleGenderButtonPressed()
	var/icon/I = new('BiggerChargenButtons.dmi', "MalePressedIn")
	var/iconfile = fcopy_rsc(I)
	winset(src, "maleButton", "image=\ref[iconfile]")

	var/icon/FemaleButton = new('BiggerChargenButtons.dmi', "FemaleBig")
	var/FemaleButtonIcon = fcopy_rsc(FemaleButton)
	winset(src, "femaleButton", "image=\ref[FemaleButtonIcon]")

mob/proc/FemaleGenderButtonPressed()
	var/icon/I = new('BiggerChargenButtons.dmi', "FemalePressedIn")
	var/iconfile = fcopy_rsc(I)
	winset(src, "FemaleButton", "image=\ref[iconfile]")

	var/icon/MaleButton = new('BiggerChargenButtons.dmi', "MaleBig")
	var/MaleButtonIcon = fcopy_rsc(MaleButton)
	winset(src, "maleButton", "image=\ref[MaleButtonIcon]")


mob/proc/ShowStaticButtons()
	var/icon/rightArrow = new('BiggerChargenButtons.dmi', "RotateRightBig")
	var/rightArrowIcon = fcopy_rsc(rightArrow)
	winset(src,"iconRight", "image=\ref[rightArrowIcon]")

	var/icon/leftArrow = new('BiggerChargenButtons.dmi', "RotateLeftBig")
	var/leftArrowIcon = fcopy_rsc(leftArrow)
	winset(src,"iconLeft", "image=\ref[leftArrowIcon]")

	var/icon/hairButton = new('CharacterCreationUIFunctions.dmi', "AltHairButton")
	var/hairButtonIcon = fcopy_rsc(hairButton)
	winset(src,"selectHair", "image=\ref[hairButtonIcon]")

	var/icon/subRaceButton = new('CharacterCreationUIFunctions.dmi', "SubRaceButton")
	var/SubRaceButtonIcon = fcopy_rsc(subRaceButton)
	winset(src,"selectSubrace", "image=\ref[SubRaceButtonIcon]")	

	var/icon/baseButton = new('CharacterCreationUIFunctions.dmi', "BasesButton")
	var/baseButtonIcon = fcopy_rsc(baseButton)
	winset(src,"selectBase", "image=\ref[baseButtonIcon]")

	var/icon/createButton = new('CharacterCreationUIFunctions.dmi', "Create")
	var/createButtonIcon = fcopy_rsc(createButton)
	winset(src,"createCharacterButton", "image=\ref[createButtonIcon]")