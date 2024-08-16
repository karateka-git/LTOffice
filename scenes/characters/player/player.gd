extends CharacterBody2D

@export var speed = 20.0

enum PlayerState { A_IDLE, D_IDLE, S_IDLE, W_IDLE, A_WALK, D_WALK, S_WALK, W_WALK }

var click_position = Vector2(0, 0)
var player_state = PlayerState.D_IDLE


func _ready():
	click_position = Vector2(position.x, position.y)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		click_position = get_global_mouse_position()
		#click_position = to_global(event.position)
	elif event is InputEventScreenTouch and event.pressed:
		click_position = get_global_mouse_position()
		#click_position = get_canvas_transform().affine_inverse().translated(event.position).origin

func _physics_process(delta):
	var target_position = (click_position - position).normalized()
	velocity = target_position * speed
	var collision = move_and_slide()
	if collision:
		click_position = position
	
	update_player_state(click_position)

func update_player_state(target_position):
	var dir = position.direction_to(click_position)

	if position.distance_to(target_position) < 3:
		match player_state:
			PlayerState.A_WALK: player_state = PlayerState.A_IDLE
			PlayerState.D_WALK: player_state = PlayerState.D_IDLE
			PlayerState.W_WALK: player_state = PlayerState.W_IDLE
			PlayerState.S_WALK: player_state = PlayerState.S_IDLE
	else:
		if dir.x < 0 and absf(dir.y) < absf(dir.x):
			player_state = PlayerState.A_WALK
		elif dir.x > 0 and absf(dir.y) < absf(dir.x):
			player_state = PlayerState.D_WALK
		elif dir.y < 0 and absf(dir.y) > absf(dir.x):
			player_state = PlayerState.W_WALK
		elif dir.y > 0 and absf(dir.y) > absf(dir.x):
			player_state = PlayerState.S_WALK
		else: 
			player_state = PlayerState.D_IDLE
	
	play_player_anim()

func play_player_anim():
	match player_state:
		PlayerState.A_IDLE: $AnimatedSprite2D.play("a-idle")
		PlayerState.D_IDLE: $AnimatedSprite2D.play("d-idle")
		PlayerState.S_IDLE: $AnimatedSprite2D.play("s-idle")
		PlayerState.W_IDLE: $AnimatedSprite2D.play("w-idle")
		PlayerState.A_WALK: $AnimatedSprite2D.play("a-walk")
		PlayerState.D_WALK: $AnimatedSprite2D.play("d-walk")
		PlayerState.S_WALK: $AnimatedSprite2D.play("s-walk")
		PlayerState.W_WALK: $AnimatedSprite2D.play("w-walk")
