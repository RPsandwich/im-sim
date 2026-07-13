extends CSGBox3D
var already_taken = false
var is_open = false
@onready var hinge = $Bible_Hinge
@onready var bible_sound = $BibleSound
func interact():
	var player = get_tree().get_first_node_in_group("player")
	
	if not is_open:
		open_bible(player)
	else:
		player.show_message("The Bible is empty.")
func open_bible(player):
	is_open = true
	bible_sound.play()
	var tween = create_tween()
	tween.tween_property(hinge, "rotation:z", deg_to_rad(-110), 0.5)
	
	if not already_taken:
		already_taken = true
		player.add_item("key")
		player.show_message("I found a key hidden in the Bible.")
	else:
		player.show_message("The Bible is empty.")
