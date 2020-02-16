










/datum/game_mode
	var/list/datum/mind/wizards = list()

/datum/game_mode/proc/forge_wizard_objectives(datum/mind/wizard)
	if (config.objectives_disabled)
		return

	switch(rand(1,100))
		if(1 to 30)

			var/datum/objective/assassinate/kill_objective = new
			kill_objective.owner = wizard
			kill_objective.find_target()
			wizard.objectives += kill_objective

			if (!(locate(/datum/objective/escape) in wizard.objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = wizard
				wizard.objectives += escape_objective
		if(31 to 60)
			var/datum/objective/steal/steal_objective = new
			steal_objective.owner = wizard
			steal_objective.find_target()
			wizard.objectives += steal_objective

			if (!(locate(/datum/objective/escape) in wizard.objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = wizard
				wizard.objectives += escape_objective

		if(61 to 100)
			var/datum/objective/assassinate/kill_objective = new
			kill_objective.owner = wizard
			kill_objective.find_target()
			wizard.objectives += kill_objective

			var/datum/objective/steal/steal_objective = new
			steal_objective.owner = wizard
			steal_objective.find_target()
			wizard.objectives += steal_objective

			if (!(locate(/datum/objective/survive) in wizard.objectives))
				var/datum/objective/survive/survive_objective = new
				survive_objective.owner = wizard
				wizard.objectives += survive_objective

		else
			if (!(locate(/datum/objective/hijack) in wizard.objectives))
				var/datum/objective/hijack/hijack_objective = new
				hijack_objective.owner = wizard
				wizard.objectives += hijack_objective
	return


/datum/game_mode/proc/name_wizard(mob/living/carbon/human/wizard_mob)
	//Allows the wizard to choose a custom name or go with a random one. Spawn 0 so it does not lag the round starting.
	var/wizard_name_first = pick(wizard_first)
	var/wizard_name_second = pick(wizard_second)
	var/randomname = "[wizard_name_first] [wizard_name_second]"
	spawn(0)
		var/newname = sanitize_safe(input(wizard_mob, "You are the Space Wizard. Would you like to change your name to something else?", "Name change", randomname) as null|text, MAX_NAME_LEN)

		if (!newname)
			newname = randomname

		wizard_mob.real_name = newname
		wizard_mob.name = newname
		if(wizard_mob.mind)
			wizard_mob.mind.name = newname
	return


/datum/game_mode/proc/greet_wizard(datum/mind/wizard, you_are=1)
	if (you_are)
		to_chat(wizard.current, "<span class='danger'>You are the Space Wizard!</span>")
	to_chat(wizard.current, "<B>The Space Wizards Federation has given you the following tasks:</B>")
	if(!config.objectives_disabled)
		var/obj_count = 1
		for(var/datum/objective/objective in wizard.objectives)
			to_chat(wizard.current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
			obj_count++
	else
		to_chat(wizard.current, "<span class='info'>Within the rules,</span> try to act as an opposing force to the crew. Further RP and try to make sure other players have </i>fun<i>! If you are confused or at a loss, always adminhelp, and before taking extreme actions, please try to also contact the administration! Think through your actions and make the roleplay immersive! <b>Please remember all rules aside from those without explicit exceptions apply to antagonists.</i></b>")
	return


/*/datum/game_mode/proc/learn_basic_spells(mob/living/carbon/human/wizard_mob)
	if (!istype(wizard_mob))
		return
	if(!config.feature_object_spell_system)
		wizard_mob.verbs += /client/proc/jaunt
		wizard_mob.mind.special_verbs += /client/proc/jaunt
	else
		wizard_mob.spell_list += new /obj/effect/proc_holder/spell/targeted/ethereal_jaunt(usr)
*/

/datum/game_mode/proc/equip_wizard(mob/living/carbon/human/wizard_mob)
	if (!istype(wizard_mob))
		return

	//So zards properly get their items when they are admin-made.
	qdel(wizard_mob.wear_suit)
	qdel(wizard_mob.head)
	qdel(wizard_mob.shoes)
	qdel(wizard_mob.r_hand)
	qdel(wizard_mob.r_store)
	qdel(wizard_mob.l_store)

	wizard_mob.equip_to_slot_or_del(new /obj/item/device/radio/headset(wizard_mob), SLOT_L_EAR)
	wizard_mob.equip_to_slot_or_del(new /obj/item/clothing/under/lightpurple(wizard_mob), SLOT_W_UNIFORM)
	wizard_mob.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(wizard_mob), SLOT_SHOES)
	wizard_mob.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe(wizard_mob), SLOT_WEAR_SUIT)
	wizard_mob.equip_to_slot_or_del(new /obj/item/clothing/head/wizard(wizard_mob), SLOT_HEAD)
	if(wizard_mob.backbag == 2) wizard_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(wizard_mob), SLOT_BACK)
	if(wizard_mob.backbag == 3) wizard_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel/norm(wizard_mob), SLOT_BACK)
	if(wizard_mob.backbag == 4) wizard_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(wizard_mob), SLOT_BACK)
	wizard_mob.equip_to_slot_or_del(new /obj/item/weapon/storage/box(wizard_mob), SLOT_IN_BACKPACK)
//	wizard_mob.equip_to_slot_or_del(new /obj/item/weapon/scrying_gem(wizard_mob), SLOT_L_STORE) For scrying gem.
	wizard_mob.equip_to_slot_or_del(new /obj/item/weapon/teleportation_scroll(wizard_mob), SLOT_R_STORE)
//	wizard_mob.equip_to_slot_or_del(new /obj/item/weapon/spellbook(wizard_mob), slot_r_hand)

	to_chat(wizard_mob, "<span class='info'>You will find a list of available spells in your spell book. Choose your magic arsenal carefully.</span>")
	to_chat(wizard_mob, "<span class='info'>In your pockets you will find a teleport scroll. Use it as needed.</span>")
	wizard_mob.mind.store_memory("<B>Remember:</B> do not forget to prepare your spells.")
	wizard_mob.update_icons()
	return 1

/datum/game_mode/proc/auto_declare_completion_wizard()
	var/text = ""
	if(wizards.len)
		text += printlogo("wizard", "wizards/witches")

		for(var/datum/mind/wizard in wizards)
			text += printplayerwithicon(wizard)

			var/count = 1
			var/wizardwin = 1
			if(!config.objectives_disabled)
				for(var/datum/objective/objective in wizard.objectives)
					if(objective.check_completion())
						text += "<BR><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
						feedback_add_details("wizard_objective","[objective.type]|SUCCESS")
					else
						text += "<BR><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>"
						feedback_add_details("wizard_objective","[objective.type]|FAIL")
						wizardwin = 0
					count++

				if(wizard.current && wizard.current.stat!=2 && wizardwin)
					text += "<BR><FONT color='green'><B>The wizard was successful!</B></FONT>"
					feedback_add_details("wizard_success","SUCCESS")
					score["roleswon"]++
				else
					text += "<BR><FONT color='red'><B>The wizard has failed!</B></FONT>"
					feedback_add_details("wizard_success","FAIL")
				if(wizard.current && wizard.current.spell_list)
					text += "<BR><B>[wizard.name] used the following spells: </B>"
					var/i = 1
					for(var/obj/effect/proc_holder/spell/S in wizard.current.spell_list)
						var/icon/spellicon = icon('icons/mob/actions.dmi', S.action_icon_state)
						end_icons += spellicon
						var/tempstate = end_icons.len
						text += {"<BR><img src="logo_[tempstate].png"> [S.name]"}
						if(wizard.current.spell_list.len > i)
							text += ", "
						i++
				text += "<BR>"
		text += "<HR>"
	return text