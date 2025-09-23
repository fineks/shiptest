#define SAND_LETHAL 300
#define SAND_STAGE_1 56
#define SAND_STAGE_2 140
// Компонент для уникума поедающего песок
// По факту не более чем счётчик для ивентов при поедании песка
/datum/component/sand_eater
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/sand_eaten = 0 // Сколько песка уже съел
	var/sand_limit = SAND_LETHAL // Сколько песка можно съесть до того как начнутся проблемы

/datum/component/sand_eater/Initialize()
	RegisterSignal(parent, "sand_eaten", PROC_REF(on_consume))

// Вызывается при поедании песка
/datum/component/sand_eater/proc/on_consume(mob/living/carbon/eater)
	sand_eaten++
	if(sand_eaten <= SAND_STAGE_1)
		if(prob(5))
			eater.balloon_alert(eater, pick("Кажется это был мой зуб...","Твёрдый кусочек...","Ауч!","Песок в зубах неприятен."))
			eater.apply_damage(5 + rand(5), BRUTE, BODY_ZONE_HEAD)
		if(prob(25))
			eater.adjustOrganLoss(ORGAN_SLOT_STOMACH, 0.5)
	// else if(sand_eaten <= SAND_STAGE_2)

	return



#undef SAND_LETHAL
#undef SAND_STAGE_1
#undef SAND_STAGE_2
