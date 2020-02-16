/obj/effect/proc_holder/magic/conjure_item
	name = "Conjure item"
	desc = ""
	mana_cost = 0

/obj/effect/proc_holder/magic/conjure_item/check_turf_cast(turf/target)
	if(is_blocked_turf(target))
		to_chat(owner.current, "<span class='wizard'>This place is occupied! I can't conjure an item here!</span>")
		return
	return TRUE


// Instead of making many closets, I could make one /closet/wizard, with various objects being spawned in atom_init. But in original file it is told to use PopulateContents to fill it, so...
/obj/structure/closet/randommeds/PopulateContents()
	for(var/i in 1 to 17)
		new /obj/random/meds/medical_supply(src)

/obj/structure/closet/randomtools/PopulateContents()
	for(var/i in 1 to 17)
		new /obj/random/tools/tech_supply/guaranteed(src)

/obj/structure/closet/randomweapons/PopulateContents()
	for(var/i in 1 to 4)
		new /obj/random/guns/weapon_item(src)
	for(var/k in 1 to 4)
		new pick(subtypesof(/obj/item/weapon/melee))

/obj/structure/closet/randomfood/PopulateContents()
	for(var/i in 1 to 23)
		new /obj/random/foods/food_without_garbage(src)

/obj/structure/closet/randomfluff/PopulateContents()
	for(var/i in 1 to 18)
		new /obj/random/misc/pack(src)

/obj/structure/closet/randomclothes/PopulateContents()
	for(var/i in 1 to 21)
		new /obj/random/cloth/random_cloth(src)

//bad food spawn

/obj/effect/proc_holder/magic/conjure_item/cast_on_turf(turf/target)
	var/A = input("What do you desire?", "Wish") in list("Medicines", "Tools", "Weapons", "Clothes", "Food and drinks", "Fluff", "CANCEL")
	if(!A)
		return
	var/obj/structure/closet/closet_to_spawn
	switch(A)
		if("Medicines")
			closet_to_spawn = /obj/structure/closet/randommeds
		if("Tools")
			closet_to_spawn = /obj/structure/closet/randomtools
		if("Weapons")
			closet_to_spawn = /obj/structure/closet/randomweapons
		if("Food and drinks")
			closet_to_spawn = /obj/structure/closet/randomfood
		if("Fluff")
			closet_to_spawn = /obj/structure/closet/randomfluff
		if("Clothes")
			closet_to_spawn = /obj/structure/closet/randomclothes
		else
			return
	new /obj/effect/falling_effect(target, closet_to_spawn)
















