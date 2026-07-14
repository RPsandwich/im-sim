extends Node3D

var is_open = false

func interact():
	var player = get_tree().get_first_node_in_group("player")
	
	if not is_open:
		is_open = true
		var tween = create_tween()
		tween.tween_property(self, "position:y", position.y - 2.24, 0.8)
		player.show_message("The painting slides down revealing a safe...")
	else:
		player.show_message("A safe is hidden behind the painting.")
