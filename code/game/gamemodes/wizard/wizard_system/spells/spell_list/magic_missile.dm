/obj/effect/proc_holder/magic/shoot/magic_missile
	name = "Magic missile"
	desc = ""
	mana_cost = 0
	projectile = /obj/item/projectile/magic/magic_missile
//	shootsound = 'sound/effects/dark_blast.ogg'

// Shooting sound
// Fly through wizards

/obj/item/projectile/magic/magic_missile
	name = "magic missile"
	icon_state = "magicm"
	nodamage = FALSE
	damage = 10
	weaken = 5
	step_delay = 5
	damage_type = BURN
