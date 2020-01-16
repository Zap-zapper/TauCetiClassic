/obj/effect/proc_holder/magic/brainrot
	name = "Brainrot"		//Change name
	desc = ""
	mana_cost = 0
	cooldown = 30


/obj/effect/proc_holder/magic/brainrot/check_mob_cast(mob/living/target)
	if(!ishuman(target))
		to_chat(owner.current, "<span class='wizard'>I can't influence this creature's mind!</span>")
		return

	if(target.stat == DEAD)
		to_chat(owner.current, "<span class='wizard'>Aren't you quite brainrotten yourself, ordering me to cast this spell on a dead creature?</span>")
		return
	return TRUE



/obj/effect/proc_holder/magic/brainrot/cast_on_mob(mob/living/carbon/human/target)
	if(ismindshielded(target))		//Wizard still wastes mana and time
		to_chat(target, "<span class='danger'>Your mindshield implant suddenly beeps!</span>")
		to_chat(owner.current, "<span class = 'wizard'>Something prevents my magic to affect this creature's brain!</span>")
		return

	if(!target.eye_blind || !target.ear_deaf)
		to_chat(target, "<font color = 'red'>Suddenly, you vision becomes darker and darker. All sounds are becoming more and more distant...</font>")
	target.eye_blind += BRAINROT_BLIND
	target.ear_deaf += BRAINROT_DEAF
	target.silent += BRAINROT_SILENCE
	message_admins("[usr] ([usr.ckey]) blinded, deafened and silenced [target] ([target.ckey]) using [src.name] spell.(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>)")
	log_game("[usr] ([usr.ckey]) blinded, deafened and silenced [target] ([target.ckey]) using [src.name] spell.")


#undef BRAINROT_DELAY
#undef BRAINROT_MANACOST
#undef BRAINROT_STUN_REDUCTION
#undef BRAINROT_HALLOSS_REDUCTION
#undef BRAINROT_PAIN_REDUCTION
#undef BRAINROT_BLIND
#undef BRAINROT_DEAF
#undef BRAINROT_PAIN
#undef BRAINROT_SILENCE
#undef BRAINROT_BRAIN_DAMAGE