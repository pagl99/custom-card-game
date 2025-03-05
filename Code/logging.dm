mob/proc/adminLog(Info)
	var/logCount=0
	if(src.client)
		var/date = time2text(world.realtime)
		LogStart
		logCount+=1
		var/userLog=file("Admin/UserLogs/[src.ckey]/[src.ckey][logCount].txt")
		if(fexists(userLog))
			var/size=length(userLog)
			if(size>(1024*100))
				goto LogStart
			else
				userLog<<"<br><br>[Info] - [date]"
		else
			userLog<<"<br>[Info] - [date]"
	return