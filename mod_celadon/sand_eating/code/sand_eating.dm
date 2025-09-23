// Добавляем вкус песка базовому песку
/obj/item/stack/ore/glass
	var/list/tastes = list("pure silicon" = 1, "tasteless grains" = 1, "stupid" = 1, "sand" = 2, "dry" = 1, "дфывыфДЖВЫЧВЧЫФ" = 1, "dessert" = 1, "sugar without sugar" = 1)
	var/sand_type = SEAFOOD

/obj/item/stack/ore/glass/microwave_act(obj/machinery/microwave/M)
	. = ..()
	src = new refined_type


// Делаем песок съедобным
/obj/item/stack/ore/glass/Initialize()
	. = ..()
	var/perfect_value = 0
	for(var/reagent in grind_results)
		perfect_value += grind_results[reagent]
	AddComponent(/datum/component/edible,\
		eat_time = 8, \
		bite_consumption = perfect_value,\
		volume = perfect_value, \
		initial_reagents = grind_results, \
		foodtypes = sand_type, \
		tastes = tastes, \
		food_flags = FOOD_FINGER_FOOD,\
		check_liked = CALLBACK(src, PROC_REF(on_consume)))
//			 ↑                                    ↑
//		ВОТ ЭТО анальный костыль ибо я не знаю как по другому сделать без залаза в кор код
//		Прок on_consume не зависимо от твоих желаний делаеет QDEL всей охабки песочка
//		А прок after_consume не успевает вызваться, и мы не получаем должного комичного эффекта поедания песка
//		По этому мы передаём это говно в check_liked, который вызывается до этих двоих, но уже после того как мы захавали песка
//		Но мы всё ещё не можем по людски предотвратить удаление всей пачки песка а не одной кучки, по этому мы обманываем
//		проверку '!owner.reagents.total_volume' путём этого костыля
// 		P.S.
// 		Rстати, из-за этого костыля чуваки с квирком Ageusia(не сутвуешь вкусы) не могут распробовать утончённый вкус песка и просмаковать каждую кучку,
// 		и по этому cжирают всю охабку разом.
// 		Давайте сойдёмся на то что это фича. Код еды ужасен.


/obj/item/stack/ore/glass/proc/on_consume(mob/living/eater, mob/living/feeder)
	//Перезаполнение песка для работы костыля
	if(amount > 1)
		amount--
		for(var/reagent in grind_results)
			reagents.add_reagent(reagent, grind_results[reagent], tastes.Copy())
	//Конец костыля

// /obj/item/stack/ore/glass/proc/after_consume(mob/living/eater, mob/living/feeder)
	// if(parent.GetComponent(/datum/component/sand_eater))
