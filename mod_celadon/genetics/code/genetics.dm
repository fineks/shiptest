// Файл оверрайда проков мутаций
// К сожалению тут будет дубликация кода из оригинальных файлов, но что поделать, я не хочу залазить в кор код

// Hulk - Убрать толстые пальцы
/datum/mutation/human/hulk/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_STUNIMMUNE, GENETIC_MUTATION)
	ADD_TRAIT(owner, TRAIT_PUSHIMMUNE, GENETIC_MUTATION)
	// REMOVE_TRAIT(owner, TRAIT_CHUNKYFINGERS, GENETIC_MUTATION) Это мы убрали
	ADD_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, GENETIC_MUTATION)
	ADD_TRAIT(owner, TRAIT_HULK, GENETIC_MUTATION)
	owner.update_body_parts()
	SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "hulk", /datum/mood_event/hulk)
	RegisterSignal(owner, COMSIG_HUMAN_EARLY_UNARMED_ATTACK, PROC_REF(on_attack_hand))
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mutation/human/hulk/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_STUNIMMUNE, GENETIC_MUTATION)
	REMOVE_TRAIT(owner, TRAIT_PUSHIMMUNE, GENETIC_MUTATION)
	// REMOVE_TRAIT(owner, TRAIT_CHUNKYFINGERS, GENETIC_MUTATION) Это мы убрали
	REMOVE_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, GENETIC_MUTATION)
	REMOVE_TRAIT(owner, TRAIT_HULK, GENETIC_MUTATION)
	owner.update_body_parts()
	SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "hulk")
	UnregisterSignal(owner, COMSIG_HUMAN_EARLY_UNARMED_ATTACK)
	UnregisterSignal(owner, COMSIG_MOB_SAY)

// Space Adaptation - возвращаем и накидываем цены
/datum/mutation/human/space_adaptation
	name = "Space Adaptation"
	desc = "A strange mutation that renders the host immune to the vacuum of space. Will still need an oxygen supply."
	quality = POSITIVE
	difficulty = 16
	text_gain_indication = "<span class='notice'>Your body feels warm!</span>"
	time_coeff = 5
	instability = 40

/datum/mutation/human/space_adaptation/New(class_ = MUT_OTHER, timer, datum/mutation/human/copymut)
	..()
	if(!(type in visual_indicators))
		visual_indicators[type] = list(mutable_appearance('icons/effects/genetics.dmi', "fire", -MUTATIONS_LAYER))

/datum/mutation/human/space_adaptation/get_visual_indicator()
	return visual_indicators[type][1]

/datum/mutation/human/space_adaptation/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_RESISTCOLD, "space_adaptation")
	ADD_TRAIT(owner, TRAIT_RESISTLOWPRESSURE, "space_adaptation")

/datum/mutation/human/space_adaptation/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_RESISTCOLD, "space_adaptation")
	REMOVE_TRAIT(owner, TRAIT_RESISTLOWPRESSURE, "space_adaptation")


// X-ray Vision - повысить стоимость до 45
/datum/mutation/human/thermal/x_ray
	instability = 45

// cloak of darkness - Добавить. Было лень смотреть логику его работы на парадизе, по этому написал свою

/datum/mutation/human/chameleon/darkcloaka
	name = "Cloak of darkness"
	desc = "A genome that causes the holder's skin to become transparent in the dark."
	quality = POSITIVE
	difficulty = 16
	text_gain_indication = span_notice("You feel one with darkness.")
	text_lose_indication = span_notice("You feel oddly exposed.")
	instability = 25
	var/broken = FALSE
	conflicts = list(/datum/mutation/human/chameleon)



/datum/mutation/human/chameleon/darkcloaka/proc/update_alpha()
	if(!owner)
		return
	var/turf/T = owner.loc
	var/light_amount = T.get_lumcount()
	// Мне всё ещё не нравится как это работает
	if(!broken)
		owner.alpha = max(owner.alpha*(light_amount+0.1),(light_amount+0.2)*255)
	else
		owner.alpha += 15

// Вызывается при поломке инвиза (атака, получение урона)
/datum/mutation/human/chameleon/darkcloaka/proc/break_alphability(var/strength,var/delay)
	broken = TRUE
	owner.alpha = owner.alpha + strength // Не отсвечиваем
	addtimer(CALLBACK(src,PROC_REF(restore_alphability)), delay, TIMER_UNIQUE|TIMER_OVERRIDE)

/datum/mutation/human/chameleon/darkcloaka/proc/restore_alphability()
	if(!owner)
		return
	broken = FALSE

/datum/mutation/human/chameleon/darkcloaka/on_acquiring(mob/living/carbon/human/owner)
	.=..()
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(on_damage))

/datum/mutation/human/chameleon/darkcloaka/on_losing(mob/living/carbon/human/owner)
	if(owner)
		UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMAGE)
	..()

/datum/mutation/human/chameleon/darkcloaka/on_life()
	update_alpha()

//Бег повышает прозрачность
/datum/mutation/human/chameleon/darkcloaka/on_move()
	SIGNAL_HANDLER

	update_alpha()

// Получаем/даём пизды - ломаем инвиз
/datum/mutation/human/chameleon/darkcloaka/on_attack_hand(atom/target, proximity)
	SIGNAL_HANDLER

	if(!proximity) //stops tk from breaking chameleon
		return

	break_alphability(15, 2 SECONDS)

/datum/mutation/human/chameleon/darkcloaka/proc/on_damage()
	SIGNAL_HANDLER

	break_alphability(50,5 SECONDS)

// Рецпт
/datum/generecipe/darkcloaka
	required = "/datum/mutation/human/chameleon; /datum/mutation/human/glow/anti"
	result = DARKCLOAKA

// Теликинез фикс + do_after машинерии
/obj/machinery
	var/tk_delay = 3 SECONDS

/obj/machinery/attack_tk(mob/user)
	if(user.stat || !tkMaxRangeCheck(user, src))
		return
	new /obj/effect/temp_visual/telekinesis(get_turf(src))
	to_chat(user, span_warning("You concentrate on [src]..."))
	if(do_after(user, tk_delay,src,1,IGNORE_USER_LOC_CHANGE))
		user.UnarmedAttack(src,0)
		add_hiddenprint(user)
	return

// Сила даёт больше урона
/datum/mutation/human/strong/on_acquiring()
	if(owner)
		owner.dna.species.punchdamagelow += 5
		owner.dna.species.punchdamagehigh += 5
	..()

/datum/mutation/human/strong/on_losing()
	if(owner)
		owner.dna.species.punchdamagelow -= 5
		owner.dna.species.punchdamagehigh -= 5
	..()


// Фикс дворфа, ну или же включение столу обратно дружбу с TRAIT_PASSTABLE
/obj/structure/table/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(istype(mover, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mover
		if(HAS_TRAIT(H,TRAIT_PASSTABLE))
			return TRUE
