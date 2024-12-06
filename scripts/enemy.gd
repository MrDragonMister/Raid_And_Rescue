extends CharacterBody3D

const ENEMY_SPEED = 3
@onready var health := 100
@onready var health_bar := $"SubViewport/Control/enemy_health_bar"
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var enemy_health_display := $health_display
@onready var enemy_manager = %Enemy_manager
@onready var player = $"../../Player"
@onready var game_manager = %game_manager

func _ready():
	health_bar.value = health
	position = Global.enemy_spawn_pos

func _process(delta: float) -> void:
	
	if nav.distance_to_target() <= player.WEAPON_FORWARD_RANGE:
		# the enemy always looks at the player so an angle check is not needed
		print("attack")
	
	# Get the camera from the current viewport
	var camera = get_viewport().get_camera_3d()
	if camera:
		# Rotate the Sprite3D to face the camera's position
		enemy_health_display.look_at(camera.global_transform.origin, Vector3.UP)
	
	if Input.is_action_just_pressed("attack"):
		# attack animatie
		var angle_from_player_2_enemy = Global.get_angle_to(player, self)
		var distance_2_player = (position - player.position).length()
		if distance_2_player < player.WEAPON_FORWARD_RANGE and angle_from_player_2_enemy < deg_to_rad(player.WEAPON_ANGLE_RANGE):
			if health > health_bar.min_value:
				for n in 10:
					health -= 1
					health_bar.value = health
					await get_tree().create_timer(0.01).timeout
				if health <= health_bar.min_value:
					print(self)
					Global.change_amount_of_enemies(-1)
					queue_free()
		else:
			# miss sound effect
			pass
	"""
	if Input.is_action_just_pressed("interact"):
		if health < health_bar.max_value:
			for n in 10:
				health += 1
				health_bar.value = health
				await get_tree().create_timer(0.01).timeout
	"""

func _physics_process(delta: float) -> void:
	var direction = Vector3()
	nav.target_position = Global.player_pos
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	var player_xz_pos = Vector3(player.position.x, position.y, player.position.z)
	look_at(player_xz_pos)

	if is_on_floor():
		velocity = direction * ENEMY_SPEED
	else:
	# Add the gravity.
		velocity += get_gravity() * delta * 2
		
	move_and_slide()
