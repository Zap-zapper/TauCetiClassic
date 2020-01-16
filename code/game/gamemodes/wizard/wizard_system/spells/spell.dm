var/list/magic_spells = typesof(/obj/effect/proc_holder/magic)

/obj/effect/proc_holder/magic
	panel = "Spells"
	name = "Master Spell"
	desc = "" // Fluff
	var/mana_cost = 0
	var/req_stat = CONSCIOUS // Can this spell be cast when you are incapacitated/dead?
	var/robeless = FALSE
	var/datum/mind/owner		//Owner mind of the spell. Honestly, not sure if this is good idea, to use owner.current instead of user. And owner instead of user.mind.
	var/cooldown = 0		//In seconds
	var/cooldown_left
	var/ultimate = FALSE
	var/cast_message		//Message when finished casting
	var/list/required_schools = list()
	var/face_target = TRUE		//If user will face a target for their spell. Mostly a crutch for Decoy
	var/non_direct = FALSE
	var/range = 7

/obj/effect/proc_holder/magic/atom_init()
	cooldown_left = cooldown
	START_PROCESSING(SSobj, src)

/obj/effect/proc_holder/magic/process()
	if(cooldown_left < cooldown)
		++cooldown_left

/obj/effect/proc_holder/magic/Destroy()
	owner = null
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/proc_holder/magic/proc/can_cast()		//Nondirect spells have NO target
	if(!iswizard(owner.current))
		return FALSE
/*
	if(cooldown_left < cooldown)
		to_chat(owner.current, "<span class='wizard'>I can't cast this spell so frequently!</span>")
		owner.current << sound('sound/magic/magicfail.ogg')
		return FALSE
*/

	if(owner.wizard_power_system.mana < mana_cost)
		to_chat(owner.current, "<span class='wizard'>I have not enough mana!</span>")
		owner.current << sound('sound/magic/magicfail.ogg')
		return FALSE

	if(owner.wizard_power_system.jaunting == TRUE)
		to_chat(owner.current, "<span class='wizard'>I can not cast spells in incorporeal form!</span>")
		owner.current << sound('sound/magic/magicfail.ogg')
		return FALSE

	if(req_stat < owner.current.stat)
		to_chat(owner.current, "<span class='wizard'>How am I supposed to cast a spell when I lost consciousness? [generate_insult()]</span>")
		owner.current << sound('sound/magic/magicfail.ogg')
		return FALSE
	return TRUE



/obj/effect/proc_holder/magic/Click()
	if(!iswizard(owner.current))
		return

	if(non_direct)
		handle_targeted_cast(owner.current)
	else
		if(owner.wizard_power_system.chosen_spell != src)
			set_spell(owner)
		else
			unset_spell(owner)


/obj/effect/proc_holder/magic/proc/set_spell()
	to_chat(owner.current, "<span class='wizard'>I have prepared [name]</span>")
	owner.wizard_power_system.chosen_spell = src

/obj/effect/proc_holder/magic/proc/unset_spell()
	to_chat(owner.current, "<span class='wizard'>I have dismissed [name]</span>")
	owner.wizard_power_system.chosen_spell = null


/obj/effect/proc_holder/magic/proc/get_target_type(atom/target)
	if(range >= get_dist(owner.current, target))
		if(isliving(target))
			if(check_mob_cast(target))
				return "mob"
			else if(check_turf_cast(get_turf(target)))
				return "turf"
		else if(istype(target, /obj))
			if(check_object_cast(target))
				return "object"
			else if(check_turf_cast(get_turf(target)))
				return "turf"
		else if(isturf(target))
			if(check_turf_cast(get_turf(target)))
				return "turf"

	owner.current << sound('sound/magic/magicfail.ogg')
	return




/obj/effect/proc_holder/magic/proc/handle_targeted_cast(atom/spell_target)
	if(!can_cast())
		return

	if(face_target && spell_target != owner.current)
		owner.current.face_atom(spell_target)

	var/target_type = get_target_type(spell_target)
	if(!target_type)
		return

	targeted_cast(spell_target,target_type)
	return


/obj/effect/proc_holder/magic/proc/targeted_cast(atom/target, targettype)
//Depending on what we click, we call the appropriate proc.
//If we can't cast spell on type we click, but can cast spell on turf, we cast spell on turf, on which that object is standing
//So you won't, for example, be unable to create a forcewall because you clicked on vent, and not on turf with that vent
	switch(targettype)
		if("mob")
			cast_on_mob(target)
		if("object")
			cast_on_object(target)
		if("turf")
			cast_on_turf(get_turf(target))
		else
			return

	if(cooldown > 0)
		cooldown_left = 0
	if(!ultimate)
		owner.wizard_power_system.spend_mana(mana_cost)		//Ultimate spells spend mana at the beginning of channeling, not at the end

/obj/effect/proc_holder/magic/proc/cast_on_mob(mob/living/target)
	return

/obj/effect/proc_holder/magic/proc/cast_on_object(obj/target)
	return

/obj/effect/proc_holder/magic/proc/cast_on_turf(turf/target)
	return

/obj/effect/proc_holder/magic/proc/check_mob_cast(mob/living/target)
	if(non_direct)		//non-direct spells are cast on self, usually without checks
		return TRUE
	return

/obj/effect/proc_holder/magic/proc/check_object_cast(obj/target)
	return

/obj/effect/proc_holder/magic/proc/check_turf_cast(turf/target)
	return


/obj/effect/proc_holder/magic/shoot
	var/projectile
	var/shootsound


/obj/effect/proc_holder/magic/shoot/handle_targeted_cast(atom/target)
	if(!can_cast())
		return

	if(face_target && target != owner.current)
		owner.current.face_atom(target)

	if(istype(target, /turf))		//This fixes bug of projectile just remaining in the air, if caster tries to shoot on his own turf
		var/turf/targetturf = target
		if(locate(owner.current) in targetturf.contents)
			return
	if(shootsound)
		playsound(owner.current, shootsound, 50)
	var/obj/item/projectile/P = new projectile(owner.current.loc)
	P.Fire(target, owner.current)
	if(cooldown > 0)
		cooldown_left = 0
	if(!ultimate)
		owner.wizard_power_system.spend_mana(mana_cost)		//Ultimate spells spend mana at the beginning of channeling, not at the end



//Make a variable which prevents insult spam

/proc/generate_insult(var/capital = TRUE)		//Wizards are meanies. For some spell error messages
	var/insult = pick("[capital ? "Y" : "y"]ou truly are an idiot", "I am... at a loss of words", "[capital ? "F" : "f"]or all of my life, I have never met such an imbecile as you", "[capital ? "S" : "s"]eems like you got a severe case of brainrot", "[capital ? "Y" : "y"]ou are no smarter than a wood block")
	return insult


#undef DEFAULT_DELAY
