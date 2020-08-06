/obj/structure/altar_of_gods
	name = "Altar of the Gods"
	desc = "An altar which allows the head of the church to choose a sect of religious teachings as well as provide sacrifices to earn favor."
	icon = 'icons/obj/structures/chapel.dmi'
	icon_state = "altar"
	density = TRUE
	anchored = TRUE
	layer = CONTAINER_STRUCTURE_LAYER
	climbable = TRUE
	pass_flags = PASSTABLE
	can_buckle = TRUE
	buckle_lying = 90 //we turn to you!
	var/datum/religion_rites/performing_rite
	var/datum/religion_sect/sect //easy access
	var/datum/religion/chaplain/religion //easy access
	var/choosed_aspect = FALSE //fix multiple clicks with the bible

/obj/structure/altar_of_gods/examine(mob/user)
	. = ..()
	var/can_i_see = FALSE
	var/msg = ""
	if(isobserver(user))
		can_i_see = TRUE
	else if(isliving(user))
		var/mob/living/L = user
		if(L.mind && L.mind.holy_role)
			can_i_see = TRUE

	if(!can_i_see || global.chaplain_religion.aspects.len == 0)
		return

	msg += "<span class='notice'>The sect currently has [round(global.chaplain_religion.favor)] favor with [pick(global.chaplain_religion.deity_names)].\n</span>"
	msg += "List of available Rites:\n"
	for(var/i in global.chaplain_religion.rites_list)
		msg += i
	if(msg)
		to_chat(user, msg)

/obj/structure/altar_of_gods/MouseDrop_T(mob/target, mob/user)
	if(isliving(target))
		if(can_climb(target) && !buckled_mob && target.loc != loc)
			if(user.incapacitated())
				return
			if(iscarbon(target))
				target.loc = loc
				for(var/obj/O in src)
					O.loc = loc
				src.add_fingerprint(target)
		else
			if(can_buckle && istype(target) && !buckled_mob && istype(user))
				user_buckle_mob(target, user)

/obj/structure/altar_of_gods/attackby(obj/item/C, mob/user, params)
	//If we can sac, we do nothing but the sacrifice instead of typical attackby behavior (IE damage the structure)
	if(religion)
		for(var/aspect in religion.aspects)
			var/datum/aspect/asp = religion.aspects[aspect]
			if(asp.sacrifice(C, user))
				to_chat(user, "<span class='notice'>You offer [C]'s power to [pick(religion.deity_names)], pleasing them.</span>")
				qdel(C)
				break

	if(user.mind.holy_role < HOLY_ROLE_PRIEST)
		to_chat(user, "<span class='warning'>You don't know how to use this.</span>")
		return

	//start ritual
	if(istype(C, /obj/item/weapon/nullrod))
		if(!religion)
			to_chat(user, "<span class ='warning'>First choose aspects in your religion!</span>")
			return

		if(religion.rites_list.len == 0)
			to_chat(user, "<span class='notice'>Your religion doesn't have any rites to perform!</span>")
			return

		var/rite_select = input(user, "Select a rite to perform!", "Select a rite", null) in religion.rites_list
		if(!(src in oview(2)))
			to_chat(user, "<span class='warning'>You are too far away!</span>")
			return

		var/selection2type = religion.rites_list[rite_select]
		performing_rite = new selection2type(src)

		if(!performing_rite.perform_rite(user, src))
			QDEL_NULL(performing_rite)
		else
			performing_rite.invoke_effect(user, src)
			religion.adjust_favor(-performing_rite.favor_cost)
			QDEL_NULL(performing_rite)

	else if(istype(C, /obj/item/weapon/storage/bible) && !choosed_aspect)
		if(!sect)
			choosed_aspect = TRUE
			var/list/available_options = generate_available_sects(user)
			if(!available_options)
				return

			var/sect_select = input(user, "Select a aspects preset", "Select a preset", null) in available_options
			if(!(src in oview(2)))
				to_chat(user, "<span class='warning'>You are too far away!</span>")
				return

			sect = available_options[sect_select]
			religion = global.chaplain_religion

			if(sect.allow_aspect)
				//choose aspects for the god and his desire
				var/list/aspects = generate_aspect(user)
				if(!aspects)
					return
				sect.on_select(aspects, 3)
			else
				sect.on_select()

			//add rites
			for(var/i in religion.aspects)
				var/datum/aspect/asp = religion.aspects[i]
				for(var/rite_list in 1 to asp.power)
					for(var/rite in asp.rite["[rite_list]"])
						religion.rites_list += rite

			if(isliving(user) && user.mind && user.mind.holy_role)
				sect.on_conversion(user)

			religion.update_rites()

/obj/structure/altar_of_gods/proc/generate_available_sects(mob/user) //eventually want to add sects you get from unlocking certain achievements
	var/list/variants = list()
	for(var/type in subtypesof(/datum/religion_sect))
		var/datum/religion_sect/sect = new type(src)
		if(!sect.name)
			continue
		sect.name += global.chaplain_religion.name
		variants[sect.name] = sect
	return variants

/obj/structure/altar_of_gods/proc/generate_aspect(mob/user)
	. = list()
	for(var/i in subtypesof(/datum/aspect))
		var/datum/aspect/asp = i
		. += list(initial(asp.name) = i)
