/obj/effect/proc_holder/magic/illusion
	name = "Decoy"
	desc = ""
	mana_cost = 0
	face_target = FALSE
	var/scanned = null


/obj/effect/dummy/chameleon/illusion/proc/copy(atom/target)		//Atom because either mob or obj/item
	name = target.name
	desc = target.desc
	copying = target
	density = target.density
	anchored = FALSE
	appearance = target.appearance
	layer = initial(target.layer)
	plane = initial(target.plane)


/obj/effect/proc_holder/magic/illusion/check_turf_cast(turf/target)
	if(!scanned)
		to_chat(owner.current, "<span class='wizard'>What do you want me to create?!</span>")
		return

	if(istype(target, /turf/simulated/wall))
		to_chat(owner.current, "<span class='wizard'>How can I forge an illusion inside a wall?! You fool!</span>")
		return

	for(var/obj/effect/dummy/chameleon/illusion/decoy in target.contents)		//So won't make similiar illusions on the same tile
		if(decoy.copying == scanned)
			return
	return TRUE


/obj/effect/proc_holder/magic/illusion/check_object_cast(obj/target)
	if(!istype(target, /obj/item) && !istype(target, /obj/effect/dummy/chameleon/illusion))
		return
	return TRUE

/obj/effect/proc_holder/magic/illusion/check_mob_cast(mob/living/target)
	return TRUE


/obj/effect/proc_holder/magic/illusion/cast_on_mob(mob/living/target)
	to_chat(owner.current, "<span class='wizard'>I scanned the [target]! Now I can create decoys of it!</span>")
	scanned = target


/obj/effect/proc_holder/magic/illusion/cast_on_object(obj/target)
	if(istype(target, /obj/effect/dummy/chameleon/illusion))
		var/obj/effect/dummy/chameleon/illusion/decoy = target
		if(decoy.copying == owner.current)
			var/casterloc = owner.current.loc
			var/oridir = owner.current.dir
			owner.current.forceMove(target.loc)
			target.forceMove(casterloc)
			owner.current.dir = target.dir
			target.dir = oridir
	else
		to_chat(owner.current, "<span class='wizard'>I scanned the [target]! Now I can create decoys of it!</span>")
		scanned = target


/obj/effect/proc_holder/magic/illusion/cast_on_turf(turf/target)
	var/obj/effect/dummy/chameleon/illusion/decoy = new (target)
	decoy.copy(scanned)
	decoy.dir = owner.current.dir

	QDEL_IN(decoy, ILLUSION_LIFESPAN)

	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, decoy)
	spark_system.start()


/obj/effect/dummy/chameleon/illusion
	var/atom/copying = null

/obj/effect/dummy/chameleon/illusion/examine(mob/user)
	if(copying)
		copying.examine(user)		//Messy, because if I, for example, undress, copy will be examined as undressed, despite it being dressed. Still, the best solution against examine-check.
		return
	..()


/obj/effect/dummy/chameleon/illusion/Destroy()
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.start()
	return ..()

/obj/effect/dummy/chameleon/illusion/attackby()
	qdel(src)

/obj/effect/dummy/chameleon/illusion/attack_hand()
	qdel(src)

/obj/effect/dummy/chameleon/illusion/ex_act()
	qdel(src)

/obj/effect/dummy/chameleon/illusion/emp_act()
	qdel(src)

/obj/effect/dummy/chameleon/illusion/bullet_act()
	qdel(src)


#undef ILLUSION_MANACOST
#undef ILLUSION_LIFESPAN