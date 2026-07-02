extends CSGBox3D

func interact():
	get_tree().get_first_node_in_group("player").show_message("My old suitcase")
