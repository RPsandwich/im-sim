extends CSGBox3D

var already_taken = false

func interact():
	var player = get_tree().get_first_node_in_group("player")
	
	if already_taken:
		player.show_message("The safe is empty.")
		return
	
	already_taken = true
	player.add_item("gun")
	player.show_message("Found my \"valuables\" (a gun).")
