/datum/blackmarket_market/blackmarket
	name = "Black Market"
	shipping = list(SHIPPING_METHOD_STASH	= 10,
					SHIPPING_METHOD_DEAD_DROP	= 20,
					SHIPPING_METHOD_LTSRBT = 50)
/datum/controller/subsystem/blackmarket
	shipping_method_descriptions = list(
		SHIPPING_METHOD_LAUNCH="Launches the item at your coordinates from across deep space. Cheap, but you might not recieve your item at all. We recommend being stationary in space, away from any large structures, for best results.",
		SHIPPING_METHOD_DEAD_DROP="Our couriers will fire your item via orbital drop pod at the nearest safe abandoned structure for discreet pick up. Reliable, but you'll have to find your package yourself. We accept no responsibility for lost packages if you try to do this in empty space or the outpost.",
		SHIPPING_METHOD_LTSRBT="Long-To-Short-Range-Bluespace-Transceiver, a machine that prepares items at a remote storage location and then teleports them to the location of the LTRSBT. Secure, quick and reliable, though it ain't cheap to do."
	)
