/obj/effect/proc_holder/magic/living_lightning
	name = "Living lightning"
	desc = ""
	mana_cost = 0

// Maybe give ability to jump multiple times

/obj/effect/proc_holder/magic/living_lightning/check_turf_cast(turf/target)
	if(is_blocked_turf(target))		//Wizard should not jump INTO blocked turf, but he should jump through windows, tables, etc...
		to_chat(owner.current, "<span class='wizard'>I can not jump into solid obstacles!</span>")
		return
	for(var/turf/T in getline(owner.current, target))
		if(T == get_turf(owner.current))
			continue
		if(T.density)
			to_chat(owner.current, "<span class='wizard'>I can not jump through solid obstacles!</span>")
			return

		for(var/atom/A in T)
			if(A.density && A.opacity)
				to_chat(owner.current, "<span class='wizard'>I can not jump through solid obstacles!</span>")
				return
	return TRUE


/obj/effect/proc_holder/magic/living_lightning/cast_on_turf(turf/target)
	owner.current.tesla_ignore = TRUE
	playsound(target, 'sound/magic/lightningbolt.ogg', 100, 1)
	var/list/high_priority_objects = list()
	var/list/low_priority_objects = list()
	for(var/atom/A in view(target, 2))
		if(istype(A, /obj/machinery) || istype(A, /obj/structure))
			high_priority_objects.Add(A)
		else if(isliving(A))
			var/mob/living/L = A
			if(L.tesla_ignore)
				continue
			else
				high_priority_objects.Add(L)
		else
			low_priority_objects.Add(A)

	for(var/i in 1 to LIGHTNING_STORM_AMOUNT_OF_LIGHTNINGS)
		var/obj/to_zap
		if(high_priority_objects.len)
			to_zap = safepick(high_priority_objects)
			high_priority_objects.Remove(to_zap)
		else if(low_priority_objects.len)
			to_zap = safepick(low_priority_objects)
			low_priority_objects.Remove(to_zap)
		else
			break
		tesla_zap(get_turf(owner.current), LIGHTNING_STORM_JUMP_RANGE, LIGHTNING_STORM_POWER, to_zap)

	var/turf/start = get_turf(owner.current)
	for(var/turf/T in getline(owner.current, target))		//Going two times through that turf line, if we consider check_turf_cast(). Can be optimized but uuuh...
		if(T == start)
			continue

		for(var/mob/living/L in T)
			L.electrocute_act(30, src, def_zone = pick(BP_CHEST , BP_GROIN , BP_L_LEG , BP_R_LEG , BP_R_ARM , BP_L_ARM))

	start.Beam(target, icon_state="lightning[rand(1,12)]", icon='icons/effects/effects.dmi', time=10, beam_layer=LIGHTING_LAYER+1)
	var/datum/effect/effect/system/spark_spread/spark_system_first = new /datum/effect/effect/system/spark_spread()
	spark_system_first.set_up(5, 0, owner.current)
	spark_system_first.start()

	owner.current.forceMove(target)		//Handles unbuckling as well, so no bugs here

	var/datum/effect/effect/system/spark_spread/spark_system_second = new /datum/effect/effect/system/spark_spread()
	spark_system_second.set_up(5, 0, owner.current)
	spark_system_second.start()

	owner.current.tesla_ignore = FALSE


