mob/verb

	Say(msg as text)
		if(msg==""||!canSay)
			return
		var/sayText=copytext(msg,1,1000)
		for(var/mob/M in viewers(10))
			if(!findtext(sayText,")")&&!findtext(sayText,"(")&&!findtext(sayText,"\[")&&!findtext(sayText,"\]")&&!findtext(sayText,"{")&&!findtext(sayText,"}"))
				M << output("<font color=white>[usr] says,<font color = white> [html_encode(sayText)]","World.IC")
				src.adminLog("<font color=teal>*[src.name]([src.key]) says, '[msg]'")
			else
				M << output("<font color=white>[usr] OOCly says,<font color = white> [html_encode(sayText)]","World.OOC")
				src.adminLog("<font color=red>*[src.name]([src.key]) OOCly says, '[msg]'")

	Whisper(msg as text)
		if(msg==""||!canSay)
			return
		var/whisperText=copytext(msg,1,1000)
		for(var/mob/M in viewers(2))
			if(!M in viewers(5))
				M << output("<font color=white>[usr] whispers something.")
			if(!findtext(whisperText,")")&&!findtext(whisperText,"(")&&!findtext(whisperText,"\[")&&!findtext(whisperText,"\]")&&!findtext(whisperText,"{")&&!findtext(whisperText,"}"))
				M << output("<font color=white>[usr] whispers,<font color = white> [html_encode(whisperText)]","World.IC")
				src.adminLog("<font color=teal>*[src.name]([src.key]) whispers, '[msg]'")
			else
				M << output("<font color=white>[usr] OOCly whispers,<font color = white> [html_encode(whisperText)]","World.OOC")
				src.adminLog("<font color=red>*[src.name]([src.key]) OOCly whispers, '[msg]'")				
