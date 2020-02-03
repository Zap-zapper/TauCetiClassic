/obj/effect/proc_holder/magic/haze
	name = "White haze"
	desc = ""
	mana_cost = 0
	cooldown = 0

/obj/effect/proc_holder/magic/haze/check_turf_cast(turf/target)
	if(is_blocked_turf(target))
		return
	return TRUE

/obj/effect/proc_holder/magic/haze/cast_on_turf(turf/target)
	new /obj/effect/effect/smoke/white_haze(target)


/obj/effect/effect/smoke/white_haze
	name = "strange haze"
	alpha = 50
	time_to_live = HAZE_LINGER_TIME
	var/power = 3
	var/spreading = TRUE
	var/times_spreaded = 0

/obj/effect/effect/smoke/white_haze/atom_init()
	. = ..()
	var/icon/I = icon('icons/effects/chemsmoke.dmi')
	I += "#FFFFFF"
	icon = I
	animate(src, alpha = 250, time = 50)
	START_PROCESSING(SSobj, src)


/obj/effect/effect/smoke/white_haze/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)


/obj/effect/effect/smoke/white_haze/affect(atom/A)
	if(isliving(A))
		var/mob/living/M = A
		M.take_bodypart_damage(power)
		if(ishuman(M))
			M.adjustCloneLoss(power)
			if(power > 8)
				M.emote("scream",,, 1)

			if(prob(power))
				var/bodypart = pick(list(BP_R_ARM , BP_L_ARM , BP_R_LEG , BP_L_LEG))
				var/mob/living/carbon/human/H = M
				var/obj/item/organ/external/BP = H.bodyparts_by_name[bodypart]
				if (BP && !(BP.is_stump))
					BP.droplimb(no_explode = FALSE, clean = TRUE, disintegrate = DROPLIMB_BLUNT)

		else if(issilicon(M))
			M.emp_act(max(3-power,1))
	else if(istype(A, /obj/item))
		var/obj/item/O = A
		if(!O.unacidable)
			if(prob(20))
				if(prob(50))
					new /obj/effect/decal/cleanable/ash(O.loc)
				qdel(O)


/obj/effect/effect/smoke/white_haze/process()
	if(power < 12)
		++power
	if(spreading)		//I do not use smoke_system here, to avoid clouds overlapping
		if(times_spreaded < 4)
			for(var/direction in alldirs)
				if(locate(/obj/effect/effect/smoke) in get_step(src, direction) || is_blocked_turf(get_step(src,direction)))
					continue
				else
					var/obj/effect/effect/smoke/white_haze/haze = new (get_step(src, direction))
					haze.times_spreaded = times_spreaded+1
			spreading = FALSE
		else
			spreading = FALSE


	for(var/atom/A in get_turf(src))
		affect(A)



#undef HAZE_MANACOST
#undef HAZE_DELAY
#undef HAZE_DAMAGE_MULT
#undef HAZE_LINGER_TIME
