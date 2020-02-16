/obj/effect/proc_holder/magic/ethereal_jaunt
	name = "Ethereal jaunt"
	desc = ""
	mana_cost = 0
	cooldown = 0


/obj/effect/proc_holder/magic/ethereal_jaunt/check_mob_cast(mob/living/carbon/human/target)
	return TRUE

/obj/effect/proc_holder/magic/ethereal_jaunt/cast_on_mob(mob/living/carbon/human/target)
	// playsound(user.loc, 'sound/effects/bamf.ogg', 50, 1)
	var/obj/effect/dummy/spell_jaunt/holder = new(get_turf(target))
	flick("phaseout",holder)
	holder.dir = target.dir		//So during running, wizard won't suddenly turn it's face to viewer
	holder.master = target
	target.forceMove(holder)
	target.client.eye = holder
	holder.canmove = TRUE				//Actual shift starts here
	if(iswizard(target))
		target.mind.wizard_power_system.jaunting = TRUE
	if(target.buckled)
		target.buckled.unbuckle_mob()
	addtimer(CALLBACK(src, .proc/disappear, holder,target), 7)


/obj/effect/proc_holder/magic/ethereal_jaunt/proc/disappear(obj/effect/dummy/spell_jaunt/holder,mob/living/carbon/human/target)
	target.ExtinguishMob()
	var/image/I = image('icons/mob/blob.dmi', holder, "marker", LIGHTING_LAYER+1)
	if(target.client)
		target.client.images += I

	addtimer(CALLBACK(src, .proc/appear,I,holder,target), 40)

/obj/effect/proc_holder/magic/ethereal_jaunt/proc/appear(image/I, obj/effect/dummy/spell_jaunt/holder, mob/living/carbon/human/target)
	flick("phasein",holder)
	if(target.client)
		target.client.images -= I
	sleep(7)		//Marked
	if(target.client)
		target.client.eye = target
	qdel(holder)		//It safely releases it's contents during Destroy()
	if(iswizard(target))
		target.mind.wizard_power_system.jaunting = FALSE




