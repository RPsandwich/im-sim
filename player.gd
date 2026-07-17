extends CharacterBody3D
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const GRAVITY = 9.8
const MOUSE_SENSITIVITY = 0.002

var skip_intro = true # make false to see intro
var inventory: Array[String] = []
var intro_playing = true
var standing_y = 2.0
var lying_y = -.05
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var interact_ray = $Head/InteractRay
@onready var interact_prompt = $CanvasLayer/InteractPrompt
@onready var message_label = $CanvasLayer/MessageLabel
@onready var message_timer = $CanvasLayer/MessageTimer
@onready var title_card = $CanvasLayer/TitleCard
@onready var fade_rect = $CanvasLayer/FadeRect
@onready var gun_viewmodel = $Head/Camera3D/GunViewmodel
@onready var gun_prompt = $CanvasLayer/GunPrompt
var gun_drawn = false
var gun_prompt_seen = false
var gun_rest_position: Vector3
var gun_holster_offset = Vector3(0, -0.4, 0.2)
var gun_tween: Tween


func add_item(item_name: String):
	if not inventory.has(item_name):
		inventory.append(item_name)

func has_item(item_name: String) -> bool:
	return inventory.has(item_name)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	interact_prompt.visible = false
	message_label.visible = false
	title_card.modulate.a = 0.0
	head.rotation.x = deg_to_rad(89)
	position.y = lying_y
	gun_rest_position = gun_viewmodel.position
	gun_viewmodel.position = gun_rest_position + gun_holster_offset
	gun_viewmodel.visible = false
	if skip_intro:
		fade_rect.modulate.a = 0.0
		intro_playing = false
		position.y = standing_y
		head.rotation.x = 0.0
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		play_intro()

func play_intro():
	fade_rect.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 2.0)
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	tween = create_tween()
	tween.tween_property(title_card, "modulate:a", 1.0, 1.5)
	await tween.finished
	await get_tree().create_timer(2.0).timeout
	tween = create_tween()
	tween.tween_property(title_card, "modulate:a", 0.0, 1.5)
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	await sit_up()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if intro_playing:
			return
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		head.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed("interact"):
		if intro_playing:
			return
		var collider = interact_ray.get_collider()
		if collider and collider.has_method("interact"):
			collider.interact()
	if event.is_action_pressed("draw_gun") and has_item("gun"):
		gun_drawn = !gun_drawn
		gun_prompt_seen = true
		toggle_gun(gun_drawn)

func toggle_gun(drawn: bool):
	if gun_tween:
		gun_tween.kill()
	gun_tween = create_tween()
	if drawn:
		gun_viewmodel.visible = true
		gun_tween.tween_property(gun_viewmodel, "position", gun_rest_position, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	else:
		gun_tween.tween_property(gun_viewmodel, "position", gun_rest_position + gun_holster_offset, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		gun_tween.tween_callback(func(): gun_viewmodel.visible = false)

func _physics_process(delta):
	if intro_playing:
		velocity = Vector3.ZERO
		return
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var collider = interact_ray.get_collider()
	if collider and collider.has_method("interact"):
		interact_prompt.visible = true
	else:
		interact_prompt.visible = false
	gun_prompt.visible = has_item("gun") and not gun_prompt_seen
	move_and_slide()

func sit_up():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", standing_y, 1.5)
	tween.tween_property(self, "position:z", 2.7, 1.5)
	tween.tween_property(self, "position:x", position.x + 2, 2)
	tween.tween_property(self, "position:y", 1, 1.5)
	tween.tween_property(self, "rotation:y", deg_to_rad(-90), 1.5)
	tween.tween_property(head, "rotation:x", 0.0, 1.5)
	await tween.finished
	intro_playing = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func show_message(text):
	message_label.text = text
	message_label.visible = true
	message_timer.start()

func _on_message_timer_timeout():
	message_label.visible = false
