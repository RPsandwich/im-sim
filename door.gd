extends CSGBox3D
var is_open = false

@onready var hinge = get_parent()

func _ready():
	%HallwayOmniLight3D.visible = false
	%Hallway_light1.material.emission_enabled = false

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
	
	# Flicker the hallway light on/off twice, then settle on
	tween.parallel().tween_callback(func():
		%HallwayOmniLight3D.visible = true
		%Hallway_light1.material.emission_enabled = true
	)
	tween.tween_interval(0.1)
	tween.tween_callback(func():
		%HallwayOmniLight3D.visible = false
		%Hallway_light1.material.emission_enabled = false
	)
	tween.tween_interval(0.08)
	tween.tween_callback(func():
		%HallwayOmniLight3D.visible = true
		%Hallway_light1.material.emission_enabled = true
	)
	tween.tween_interval(0.1)
	tween.tween_callback(func():
		%HallwayOmniLight3D.visible = false
		%Hallway_light1.material.emission_enabled = false
	)
	tween.tween_interval(0.12)
	tween.tween_callback(func():
		%HallwayOmniLight3D.visible = true
		%Hallway_light1.material.emission_enabled = true
	);
