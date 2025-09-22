/obj/item/bodypart/chest/robot/microwave
	name = "Микровлновка"
	desc = "Ужасающий механизм выполняющий функции торса и микроволновой печи одновременно."
	//icon = '' TODO: Наклянчить текстуры
	icon_state = "chest"
	var/item/stock_parts/manipulator/P


/obj/item/bodypart/chest/robot/Destroy()
	QDEL_NULL(cell)
	QDEL_NULL(manipulator)
	return ..()

/obj/item/bodypart/chest/robot/microwave/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stock_parts/manipulator))
		manipulator = W
		to_chat(user, "You replace [W] in [src].")
		return TRUE
	return ..()

/obj/item/disk/surgery/microwavification
	name = "Продвинутая аугментация"
	desc = "Диск содержащий набор инструкций для продвинутой замены частей тела на такие же продвинутые технологии."
	surgeries = list(/datum/surgery/advanced/microwavification)

/datum/surgery/advanced/microwavification
	name = "Продвинутая аугментация"
	desc = "Более продвинутая версия аугментации."
	steps = list(
	/datum/surgery_step/mechanic_open,
	/datum/surgery_step/open_hatch,
	/datum/surgery_step/mechanic_unwrench,
	/datum/surgery_step/prepare_electronics,
	/datum/surgery_step/add_betterpart,
	/datum/surgery_step/mechanic_wrench,
	/datum/surgery_step/close_hatch,
	/datum/surgery_step/mechanic_close
	)
	possible_locs = list(BODY_ZONE_CHEST,BODY_ZONE_HEAD)
	requires_bodypart_type = BODYTYPE_ROBOTIC
	requires_bodypart = TRUE
	requires_tech = TRUE

/datum/surgery_step/add_betterpart
	name = "install advanced part"
	implements = list(/obj/item/circuitboard/machine/microwave = 100, /obj/item/stock_parts = 100)
	time = 10
	experience_given = MEDICAL_SKILL_ADVANCED
	var/obj/item/P

/datum/surgery/part_replacement
	name = "Part Replacement"
	steps = list(
	/datum/surgery_step/mechanic_open,
	/datum/surgery_step/open_hatch,
	/datum/surgery_step/mechanic_unwrench,
	/datum/surgery_step/prepare_electronics,
	/datum/surgery_step/add_betterpart,
	/datum/surgery_step/mechanic_wrench,
	/datum/surgery_step/close_hatch,
	/datum/surgery_step/mechanic_close)
	possible_locs = list(BODY_ZONE_CHEST,BODY_ZONE_HEAD)
	requires_bodypart_type = BODYTYPE_MICROWAVE
	requires_bodypart = TRUE


/datum/surgery_step/add_betterpart/replace
	name = "replace part"
	var/obj/item/stock_parts/manipulator/P


