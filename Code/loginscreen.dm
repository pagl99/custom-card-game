mob/verb/LoadGame()
	set hidden = 1
	src.Load()
	if(fexists("Savefiles/[src.ckey]"))
		winshow(usr,"World",1)
		winset(usr,null,"creationPreview.is-default=false;map.is-default=true;map.is-visible=true")
		winshow(usr,"Login",0)
		usr.saveable = 1
	else return

mob
	Login()
		winshow(usr,"World",0)
		winset(src,"creationPreview","is-default=false")
		winset(usr,null,"Login.is-default=true;World.is-default=false")
		winshow(usr,"Login",1)
		winshow(usr,"characterCreationMain",0)
		..()
		playerList+= src
	Logout()
		playerList-= src
		src.Save()
		..()

mob/verb/NewGame()
	set hidden = 1
	if(fexists("Savefiles/[src.ckey]"))
		alert("If you continue, the character [usr.name] will be deleted. Are you sure you wish to continue?")
		switch(input("Continue?") in list ("Yes","No"))
			if ("Yes")
				usr.canMove=0
				winset(usr,null,"Login.is-default=false;World.is-default=true")
				winshow(usr,"Login",0)
				winshow(usr, "World", 1)
				winset(usr,"World", "is-maximized=true")		
				winshow(usr,"characterCreationMain",1)
				winset(usr,"characterCreationMain", "pos=100,100")
				StartCreation()
				usr.saveable = 0
			if ("No")
				return
	usr.canMove=0
	usr.saveable = 0
	winset(usr,null,"Login.is-default=false;World.is-default=true")
	winshow(usr,"Login",0)
	winshow(usr, "World", 1)
	winset(usr,"World", "is-maximized=true")		
	winshow(usr,"characterCreationMain",1)
	winset(usr,"characterCreationMain", "pos=100,100")
	StartCreation()