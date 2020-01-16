/obj/effect/proc_holder/magic/fair_exchange
	name = "Fair exchange"
	desc = ""
	mana_cost = 0

//Messages if no item


/obj/effect/proc_holder/magic/fair_exchange/check_object_cast(obj/item/target)
	if(!istype(target,/obj/item))
		return
	if(target.flags & ABSTRACT || target.flags & NODROP)
		return
	return TRUE



/obj/effect/proc_holder/magic/fair_exchange/cast_on_object(obj/item/target)
	playsound(target.loc, 'sound/effects/phasein.ogg', 100, 1)
	for(var/mob/living/carbon/human/M in viewers(target))
		if(M.eyecheck() <= 0)
			M.flash_eyes()

	var/obj/item/new_item_type
	if(target.parent_type == /obj/item || target.parent_type == /obj/item/weapon)
		new_item_type = safepick(subtypesof(target))
	else
		new_item_type = safepick(subtypesof(target.parent_type) - target.type)

	if(!new_item_type)
		to_chat(owner.current, "<span class='wizard'>The spell failed! There is no equivalent of this item in the parallel dimension!</span>")
		return
	//Runtime, can't read newitem name
	new new_item_type(target.loc)
	message_admins("[usr] ([usr.ckey]) transformed [target] ([target.type]) into [new_item_type.name] ([new_item_type]). (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
	qdel(target)

#undef EXCHANGE_MANACOST
#undef EXCHANGE_DELAY