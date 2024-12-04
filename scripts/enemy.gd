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


# note to self: use the get angle to for deciding if an attack hits
# the get angle code is in the enemy code, but should be calculated from the perspective of the player
# change from, target, position and target stuff so it's correct
# https://forum.godotengine.org/t/how-do-i-work-with-angles-using-vector3-basis/86861/3
func get_angle_to(from:Vector3, target:Vector3) -> float:
	#Get the location of the target as a Vector2 from a top-down perspective
	var enemy_2d_position := Vector2(position.x, position.z)
	
	#Same thing as above. They both need to have the same origin.
	var player_2d_position := Vector2(target.x, target.z)
	
	#Vector from player to enemy on a top-down plane
	var relative_target_direction: Vector2 = enemy_2d_position - player_2d_position
	
	#Forward direction of self
	var forward_3d_direction: Vector3 = global_transform.basis.z
	var forward_2d_direction := Vector2(forward_3d_direction.x, forward_3d_direction.z)
	
	#Get angle to target
	var angle_to_target = forward_2d_direction.angle_to(relative_target_direction)
	return angle_to_target

func _process(delta: float) -> void:
	"""
	if nav.distance_to_target() <= 10:
		print("attack")
	"""
	# Get the camera from the current viewport
	var camera = get_viewport().get_camera_3d()
	if camera:
		# Rotate the Sprite3D to face the camera's position
		enemy_health_display.look_at(camera.global_transform.origin, Vector3.UP)

	var distance_2_player = (position - player.position).length()	
	if Input.is_action_just_pressed("attack") and distance_2_player < 3:
		if health > health_bar.min_value:
			for n in 10:
				health -= 1
				health_bar.value = health
				await get_tree().create_timer(0.01).timeout
		if health <= health_bar.min_value:
			print(self)
			get_tree().create_timer(3).timeout
			Global.change_amount_of_enemies(-1)
			queue_free()
	if Input.is_action_just_pressed("interact"):
		if health < health_bar.max_value:
			for n in 10:
				health += 1
				health_bar.value = health
				await get_tree().create_timer(0.01).timeout

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
