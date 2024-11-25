extends CharacterBody3D

const ENEMY_SPEED = 3
@onready var enemy: CharacterBody3D = $"."
@onready var health := 100
@onready var health_bar := $"SubViewport/Control/enemy_health_bar"
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var enemy_health_display := $health_display

func _ready():
	health_bar.value = health
	position = Vector3(0, 1, 0)

func _process(delta: float) -> void:
	# Get the camera from the current viewport
	var camera = get_viewport().get_camera_3d()
	if camera:
		# Rotate the Sprite3D to face the camera's position
		enemy_health_display.look_at(camera.global_transform.origin, Vector3.UP)

	if Input.is_action_just_pressed("attack"):
		if health > health_bar.min_value:
			for n in 10:
				health -= 1
				health_bar.value = health
				await get_tree().create_timer(0.01).timeout
	if Input.is_action_just_pressed("interact"):
		if health < health_bar.max_value:
			for n in 10:
				health += 1
				health_bar.value = health
				await get_tree().create_timer(0.01).timeout
				
	var player = get_node("../Player")
	var player_position = player.global_transform.origin
	var enemy_position = global_transform.origin
	var playerdir_to_enemy = player.direction_to(enemy)
	var playerinput_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var playerdir: Vector3 = (player.transform.basis * Vector3(playerinput_dir.x, 0, playerinput_dir.y)).normalized()
	if Input.is_action_just_pressed("attack"):
		if enemy_position.distance_to(player_position) <= 3:
			if playerdir_to_enemy.dot(playerdir):
				for n in 10:
					health = max(health - 1, health_bar.min_value)
					health_bar.value = health
					await get_tree().create_timer(0.01).timeout
	if Input.is_action_just_pressed("interact"):
		for n in 10:
			health = min(health + 1, health_bar.max_value)
			health_bar.value = health
			await get_tree().create_timer(0.01).timeout

func _physics_process(delta: float) -> void:
	var direction = Vector3()
	nav.target_position = Global.player_pos
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()

	if is_on_floor():
		velocity = direction * ENEMY_SPEED
	else:
	# Add the gravity.
		velocity += get_gravity() * delta * 2
		
	move_and_slide()
	
