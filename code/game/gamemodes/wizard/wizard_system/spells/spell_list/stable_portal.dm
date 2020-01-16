/obj/effect/proc_holder/magic/stable_portal
	name = "Stable portal"
	desc = ""
	mana_cost = 0
	cooldown = 50
	var/location
	non_direct = TRUE

//Remove "charging effect" or add sleep or whatever

/obj/effect/proc_holder/magic/stable_portal/check_mob_cast(mob/living/target)
	var/list/L = list()
	var/A = input("Area to open portal into", "Portal") in teleportlocs
	if(!A)
		return

	var/area/thearea = teleportlocs[A]

	for(var/turf/T in get_area_turfs(thearea.type))
		if(!is_blocked_turf(T) && !istype(T,/turf/space))
			L+=T

	var/turf/exit_loc = safepick(L)
	if(!exit_loc)
		to_chat(owner.current, "The spell matrix was unable to locate a suitable teleport destination for an unknown reason. Sorry.")
		return

	location = exit_loc
	return TRUE

/obj/effect/proc_holder/magic/stable_portal/cast_on_mob(mob/living/target)
	var/obj/effect/portal/tsci_wormhole/wormhole = new (owner.current.loc, location)
	playsound(owner.current.loc, 'sound/magic/CastSummon.ogg', 100, 1)
	message_admins("[usr] ([usr.ckey]) used [src.name] spell and opened a portal from [get_area(usr)] to [get_area(location)].(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
	QDEL_IN(wormhole, PORTAL_LIFESPAN)


#undef PORTAL_LIFESPAN
