/obj/effect/proc_holder/magic/lightning_storm
	name = "Lightning storm"
	desc = ""
	mana_cost = 0
	cooldown = 35

//Probably all four elements

/obj/effect/proc_holder/magic/lightning_storm/check_turf_cast(turf/target)
	return TRUE

/obj/effect/proc_holder/magic/lightning_storm/cast_on_turf(turf/target)
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
		tesla_zap(owner.current, LIGHTNING_STORM_JUMP_RANGE, LIGHTNING_STORM_POWER, to_zap)

	owner.current.tesla_ignore = FALSE

//message_admins("[usr] ([usr.ckey]) used [src.name] spell at [get_area(usr)].(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")


#undef LIGHTNING_STORM_MANACOST
#undef LIGHTNING_STORM_DELAY
#undef LIGHTNING_STORM_POWER
#undef LIGHTNING_STORM_AMOUNT_OF_LIGHTNINGS
#undef LIGHTNING_STORM_RANGE
#undef LIGHTNING_STORM_JUMP_RANGE



