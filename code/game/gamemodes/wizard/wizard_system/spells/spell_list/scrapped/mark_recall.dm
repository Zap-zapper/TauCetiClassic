/obj/effect/proc_holder/magic/nondirect/mark_recall
	name = "Mark & Recall"
	desc = ""
	mana_cost = 0
	var/obj/item/marked_item
	non_direct = TRUE


/obj/effect/proc_holder/magic/nondirect/mark_recall/check_mob_cast()
	var/obj/item/item_in_hand = owner.current.get_active_hand()
	if(item_in_hand)
		if(item_in_hand.flags & ABSTRACT || item_in_hand.flags & NODROP)
			return
		if(marked_item == item_in_hand)			//Error sound
			to_chat(owner.current, "<span class='wizard'>Mark removed!</span>")
			name = "Mark & Recall"
			marked_item = null
		else
			to_chat(owner.current, "<span class='wizard'>Item marked!</span>")
			name = "Recall [item_in_hand]"
			marked_item = item_in_hand
		return
	else
		if(!marked_item)
			return

		else if(marked_item && (QDELETED(marked_item) || !marked_item.loc))
			marked_item = null
			name = "Mark & Recall"
			return
	return TRUE
/obj/effect/proc_holder/magic/nondirect/mark_recall/cast_on_mob()
	owner.current.put_in_hands(marked_item)
	playsound(owner.current.loc, 'sound/magic/SummonItems_generic.ogg',100,1)


#undef RECALL_MANACOST