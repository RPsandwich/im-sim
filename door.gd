extends CSGBox3D
var is_open = false

@onready var hinge = get_parent()

func interact():
	var player = get_tree().get_first_node_in_group("player")
	
	if not player.has_item("gun"):
		player.show_message("I better grab my \"valuables\" before opening the door.")
		return
	
	if is_open:
		return
	is_open = true
	
	var tween = create_tween()
	tween.tween_property(hinge, "rotation:y", deg_to_rad(-100), 1.5)
	#player.show_message("The door creaks open.")
