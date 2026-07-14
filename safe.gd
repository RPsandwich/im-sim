extends CSGBox3D

var is_open = false

func interact():
	var player = get_tree().get_first_node_in_group("player")
	
	if is_open:
		player.show_message("The safe is already open.")
		return
	
	if not player.has_item("key"):
		player.show_message("It's locked. You need a key.")
		return
	is_open = true
	player.inventory.erase("key")
	
	var tween = create_tween()
	tween.tween_property(self, "position:x", position.x - .72, 0.5)
	player.show_message("The safe clicks open...")
	
	await get_tree().create_timer(0.5).timeout
	var lamp = get_tree().get_first_node_in_group("lamp")
	if lamp:
		if not lamp.is_on:
			lamp.interact()  # lamp was off — turn it on first
			await get_tree().create_timer(0.3).timeout  # let it actually render before flickering
		lamp.interact()  # now flicker off

	await get_tree().create_timer(2.0).timeout
	if lamp:
		lamp.interact()  # flicker back on
