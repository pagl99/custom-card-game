mob
	proc
		Save() // This is the proc that saves the player
			if(src.loc==null || src.saveable == 0)
				return
			var/savefile/File=new("Savefiles/[src.ckey]")
			File["x"]<<src.x
			File["y"]<<src.y
			File["z"]<<src.z
			Write(File)

		AutoSave()
			Save()
			spawn(3000)
			AutoSave()

		Load()
			if(client)
				if(fexists("Savefiles/[src.ckey]"))
					var/savefile/File=new("Savefiles/[src.ckey]")
					Read(File)
					File["x"]>>src.x
					File["y"]>>src.y
					File["z"]>>src.z
					src.loc = locate(src.x,src.y,src.z)
				else
					alert("You do not have any characters on this server. Create one.")