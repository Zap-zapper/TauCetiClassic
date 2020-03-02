/obj/effect/proc_holder/magic/forcewall
	name = "Forcewall"
	desc = ""
	mana_cost = 0



/obj/effect/proc_holder/magic/forcewall/check_turf_cast(turf/target)
	if(is_blocked_turf(target))
		to_chat(owner.current, "<span class='wizard'>This place is occupied! I can't forge an energy wall here!</span>")
		return
	return TRUE


/obj/effect/proc_holder/magic/forcewall/cast_on_turf(turf/target)
	new /obj/effect/forcefield/magic(target,owner.current)
	playsound(target, 'sound/magic/ForceWall.ogg', 100, 1)

/obj/effect/forcefield/magic
	var/mob/wizard

/obj/effect/forcefield/magic/atom_init(mapload, mob/wiz, timeleft = FORCEWALL_LIFESPAN)
	. = ..()
	wizard = wiz
	QDEL_IN(src, timeleft)

/obj/effect/forcefield/magic/CanPass(atom/movable/mover, turf/target)
	if(mover == wizard)
		return TRUE
	if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/P = mover
		if(P.firer == wizard)
			return TRUE
	return FALSE

#undef FORCEWALL_MANACOST
#undef FORCEWALL_LIFESPAN