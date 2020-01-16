/obj/effect/proc_holder/magic/tornado
	name = "Tornado"
	desc = ""
	mana_cost = 0
	ultimate = TRUE

//Sounds
//Debuffs on user (minus max mana)
//Special effects


/obj/effect/proc_holder/magic/tornado/check_turf_cast(turf/target)
	if(is_blocked_turf(target))
		to_chat(owner.current, "<span class='wizard'>This place is occupied! I can't summon a tornado here!</span>")
		return
	return TRUE


/obj/effect/proc_holder/magic/tornado/cast_on_turf(turf/target)
	var/obj/singularity/scrap_ball/new_tornado = new /obj/singularity/scrap_ball(target)
	QDEL_IN(new_tornado, 400)
