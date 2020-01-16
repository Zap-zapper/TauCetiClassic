/obj/effect/proc_holder/magic/elemental_snare
	name = "Elemental snare"
	desc = ""
	mana_cost = 0

/obj/effect/proc_holder/magic/elemental_snare/check_turf_cast(turf/target)
	if(is_blocked_turf(target))
		to_chat(owner.current, "<span class='wizard'>This place is occupied! I can't place a trap here!</span>")
		return
	if(locate(/obj/structure/trap) in target.contents)
		return
	return TRUE

/obj/effect/proc_holder/magic/elemental_snare/cast_on_turf(turf/target)
	var/obj/structure/trap/snare
	switch(owner.current.a_intent)
		if("help")
			snare = new /obj/structure/trap/damage(target,owner.current)
		if("disarm")
			snare = new /obj/structure/trap/chill(target,owner.current)
		if("hurt")
			snare = new /obj/structure/trap/fire(target,owner.current)
		if("grab")
			snare = new /obj/structure/trap/stun(target,owner.current)
	QDEL_IN(snare, SNARE_LIFESPAN)


#undef SNARE_MANACOST
#undef SNARE_LIFESPAN
