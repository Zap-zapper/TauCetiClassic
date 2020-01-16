/obj/effect/proc_holder/magic/agony
	name = "Agony"
	desc = ""
	mana_cost = 0


/obj/effect/proc_holder/magic/agony/check_mob_cast(mob/living/target)
	if(!ishuman(target))
		to_chat(owner.current, "<span class='wizard'>This spell works only on humans!</span>")
		return

	if(target.stat == DEAD)
		to_chat(owner.current, "<span class='wizard'>You ordered me to cause pain on dead creature... [generate_insult(FALSE)]</span>")		//random insult
		return
	return TRUE


/obj/effect/proc_holder/magic/agony/cast_on_mob(mob/living/carbon/human/target)
	if(ismindshielded(target))		//Wizard still wastes mana and time
		to_chat(target, "<span class='danger'>Your mindshield implant suddenly beeps!</span>")
		to_chat(owner.current, "<span class = 'wizard'>Something prevents my magic to affect this creature's brain!</span>")		//This spell targets brain
		return

	target.adjustHalLoss(101)
	target.emote("scream",,, 1)


	//message_admins("[usr] ([usr.ckey]) blinded, deafened and silenced[target] ([target.ckey]) using [src.name] spell.(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>)")
	//log_game("[usr] ([usr.ckey]) blinded, deafened and silenced [target] ([target.ckey]) using [src.name] spell.")
