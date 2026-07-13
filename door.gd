extends CSGBox3D
var is_open = false
func interact():
	var player = get_tree().get_first_node_in_group("player")
	
	if not player.has_item("gun"):
		player.show_message("I better grab my \"valuables\" before opening the door.")
		return
	
	if is_open:
		return
	is_open = true
	
	# TODO: actual door-open behavior goes here
	# e.g. a tween to swing/slide the door, a sound, maybe a scene transition
	player.show_message("The door creaks open.")
