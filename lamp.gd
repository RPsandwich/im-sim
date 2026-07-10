extends Node3D

var is_on = true

@onready var light = $OmniLight3D
@onready var shade = $Lamp_Shade
@onready var click_sound = $LampClick

func interact():
	is_on = !is_on
	light.visible = is_on
	shade.material.emission_enabled = is_on
	click_sound.play()
	var player = get_tree().get_first_node_in_group("player")
	#if is_on:
		#player.show_message("You turn the lamp on.")
	#else:
		#player.show_message("You turn the lamp off.")
