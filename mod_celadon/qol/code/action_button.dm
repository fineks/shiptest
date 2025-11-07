/datum/action
	//Кейбинд по настоящему
	var/full_key

/datum/action/proc/update_button_status(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	current_button.update_keybind_maptext(full_key)
	if(IsAvailable())
		current_button.color = rgb(255,255,255,255)
	else
		current_button.color = transparent_when_unavailable ? rgb(128,0,0,128) : rgb(128,0,0)

/datum/action/proc/begin_creating_bind(atom/movable/screen/movable/action_button/current_button, mob/user)
	if(!current_button || user != owner)
		return
	if(!isnull(full_key))
		full_key = null
		update_button_status(current_button)
		return
	full_key = CaptureKeybinding(user, )
	update_button_status(current_button)

/datum/action/proc/CaptureKeybinding(mob/user, datum/full_key/kb, old_key)
	var/HTML = {"
	// <div id='focus' style="outline: 0;" tabindex=0>Keybinding: [kb.full_name]<br>[kb.description]<br><br><b>Press any key to change<br>Press ESC to clear</b></div>
	// <script>
	// var deedDone = false;
	// document.onkeyup = function(e) {
	// 	if(deedDone){ return; }
	// 	var alt = e.altKey ? 1 : 0;
	// 	var ctrl = e.ctrlKey ? 1 : 0;
	// 	var shift = e.shiftKey ? 1 : 0;
	// 	var numpad = (95 < e.keyCode && e.keyCode < 112) ? 1 : 0;
	// 	var escPressed = e.keyCode == 27 ? 1 : 0;
	// 	var url = 'byond://?_src_=prefs;preference=keybindings_set;keybinding=[kb.name];old_key=[old_key];clear_key='+escPressed+';key='+e.key+';alt='+alt+';ctrl='+ctrl+';shift='+shift+';numpad='+numpad+';key_code='+e.keyCode;
	// 	window.location=url;
	// 	deedDone = true;
	// }
	// document.getElementById('focus').focus();
	// </script>
	"}
	winshow(user, "capturekeypress", TRUE)
	var/datum/browser/popup = new(user, "capturekeypress", "<div align='center'>Keybindings</div>", 350, 300)
	popup.set_content(HTML)
	popup.open(FALSE)
	onclose(user, "capturekeypress", src)

/datum/action/proc/keydown(mob/source, key, client/client, full_key)
	SIGNAL_HANDLER
	if(isnull(full_key) || full_key != src.full_key)
		return
	if(istype(source))
		if(source.next_click > world.time)
			return
		else
			source.next_click = world.time + CLICK_CD_CLICK_ABILITY
	INVOKE_ASYNC(src, PROC_REF(Trigger))

/atom/movable/screen/movable/action_button
	//Кейбинд если бы он был картинкой
	var/mutable_appearance/keybind_maptext

/atom/movable/screen/movable/action_button/proc/update_keybind_maptext(key)
	cut_overlay(keybind_maptext)
	if(!key)
		return
	keybind_maptext = new
	keybind_maptext.maptext = MAPTEXT("<span style='text-align: right'>[key]</span>")
	keybind_maptext.transform = keybind_maptext.transform.Translate(-4, length(key) > 1 ? -6 : 2) //with modifiers, its placed lower so cooldown is visible
	add_overlay(keybind_maptext)

