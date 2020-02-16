/obj/effect/proc_holder/magic/shadow_twin
	name = "Shadow twin"
	desc = ""
	mana_cost = 0
	cooldown = 35
	non_direct = TRUE


/obj/effect/proc_holder/magic/shadow_twin/check_mob_cast(mob/livingtarget)
	return TRUE

/obj/effect/proc_holder/magic/shadow_twin/cast_on_mob(mob/living/target)
	if(owner)
		var/mob/living/carbon/human/shadow_twin/shadow = new(target.loc)
		shadow.linked_mind = owner
		shadow.master = owner.current
		owner.transfer_to(shadow)

//	message_admins("[usr] ([usr.ckey]) used [src.name] spell at [get_area(usr)].(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")


/mob/living/carbon/human/shadow_twin
	var/mob/living/carbon/human/master
	var/datum/mind/linked_mind		//In case their mind will be transferred again, in death this variable will track it and send back into original body

//No spell cast, blind smoke, destroy()

/mob/living/carbon/human/shadow_twin/atom_init()
	. = ..()
	color = "#000000"

/mob/living/carbon/human/shadow_twin/apply_damage()
	transfer_back()

/mob/living/carbon/human/shadow_twin/updatehealth()
	..()
	if(health < maxHealth)
		transfer_back()

/mob/living/carbon/human/shadow_twin/proc/transfer_back()
	if(master && linked_mind)
		for(var/obj/item/I in src)
			drop_from_inventory(I)
		linked_mind.transfer_to(master)
	qdel(src)

/mob/living/carbon/human/shadow_twin/Life()
	if(!master || master.stat != CONSCIOUS)
		transfer_back()
		return
	. = ..()

/mob/living/carbon/human/shadow_twin/verb/kill_self()
	set category = "Shadow twin"
	set name = "Reunite with body"
	set desc = "Jump back to your body"

	transfer_back()