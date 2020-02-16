/obj/effect/proc_holder/magic/resurrect
	name = "Resurrect"
	mana_cost = 0
	ultimate = TRUE
	delay = 50
	cooldown = 20
	range = 1

//	user.adjustHalLoss(101) // much power, such spell, wow!
//	user.emote("scream",,, 1)
//	check robutts
//	autocast on self when dead

/obj/effect/proc_holder/magic/resurrect/cast_on_mob(mob/living/target)
	playsound(target, 'sound/magic/resurrection_cast.ogg', 100, 1)
	target.revive()

	if(!target.ckey || !target.mind)
		for(var/mob/dead/observer/ghost in dead_mob_list)
			if(target.mind == ghost.mind)
				ghost.reenter_corpse()
				to_chat(target, "<span class='notice'>You feel yourself being forcefully pulled back into your body. And then you open your eyes, realizing that you are alive...</span>")
				break

