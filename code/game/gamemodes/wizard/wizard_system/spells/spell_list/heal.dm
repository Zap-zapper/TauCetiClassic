/obj/effect/proc_holder/magic/heal
	name = "Cure"
	desc = ""
	mana_cost = 0

/obj/effect/proc_holder/magic/heal/check_mob_cast(mob/living/target)
	if(!ishuman(target))
		to_chat(owner.current, "<span class='wizard'>This spell works on humans only!</span>")
		return

	if(target.stat == DEAD)
		to_chat(owner.current, "<span class='wizard'>Such spell is too weak to resurrect dead creatures!</span>")
		return
	return TRUE


/obj/effect/proc_holder/magic/heal/cast_on_mob(mob/living/carbon/human/target)
	var/hamt = -20
	target.cure_all_viruses()
	target.remove_any_mutations()
	target.apply_damages(hamt, hamt, hamt, hamt, hamt, hamt)
	target.apply_effects(hamt, hamt, hamt)		//So no "Your clothes feels warm"
