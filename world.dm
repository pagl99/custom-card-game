mob
	glide_size = 32  // Match your tile size

mob
	Login()
		MapZoom() // Simply add this to your Login() ;)

var
	list/playerList = new()

world
	fps = 30  // or 30 for smoother movement

client
	fps = 40
	view = 15