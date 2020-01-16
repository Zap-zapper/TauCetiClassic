/obj/effect/proc_holder/magic/mind_swap
	name = "Mind swap"
	desc = ""
	mana_cost = 0
	cooldown = 0

// 5-10 seconds duration

/obj/effect/proc_holder/magic/mind_swap/check_mob_cast(mob/living/carbon/human/target)
	if(target == owner.current)
		to_chat(owner.current, "<span class = 'wizard'>[generate_insult()]</span>")
		return

	if(!ishuman(target))
		to_chat(owner.current, "<span class = 'wizard'>This spell only works on humans!</span>")
		return

	if(target.stat == DEAD)
		to_chat(owner.current, "<span class = 'wizard'>Swapping bodies with a dead person... [generate_insult()].</span>")
		return

	if(!target.key || !target.mind)
		to_chat(owner.current, "<span class = 'wizard'>They appear to be catatonic. Not even magic can affect their vacant mind.</span>")
		return

	if(target.mind.special_role in list("Wizard","Changeling","Cultist"))
		to_chat(owner.current, "<span class = 'wizard'>Their mind is resisting my spell.</span>")
		return


/obj/effect/proc_holder/magic/mind_swap/cast_on_mob(mob/living/target)		//it is impossible to change bodies with owner.current
	var/mob/living/carbon/human/caster_body = owner.current
	caster_body.whisper_say("Cor itineran'tur")				//"whispers something" should give a little hint that something happened
	if(ismindshielded(target))		//Spell is cast but target is protected by mindshield implant. Still waste cooldown and mana
		to_chat(target, "<span class='danger'>Your mindshield implant suddenly beeps!</span>")
		to_chat(owner.current, "<font color = 'purple'><span class = 'bold'>Something prevents my magic to affect this creature's brain!</span></font>")
		return

	var/mob/dead/observer/ghost = target.ghostize(can_reenter_corpse = FALSE)
	owner.transfer_to(target)
	ghost.mind.transfer_to(caster_body)
	caster_body.key = ghost.key



