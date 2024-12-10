extends CharacterBody3D

const ENEMY_SPEED = 3
const ENEMY_WEAPON_FORWARD_RANGE = 1

var health : int = 100
var attack_ready: bool = true
var direction: Vector3 = Vector3.ZERO

@onready var health_bar: = $"SubViewport/Control/enemy_health_bar"
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var enemy_health_display := $health_display
@onready var enemy_manager = %Enemy_manager
@onready var player = $"../../Player"
@onready var game_manager = %game_manager
@onready var timer: Timer = $attack_cooldown
@onready var player_health_bar = $"../../../Control/health_bar"

func _ready():
	health_bar.value = health
	position = Global.enemy_spawn_pos

func _process(delta: float) -> void:
	# Get the camera from the current viewport
	var camera = get_viewport().get_camera_3d()
	if camera:
		# Rotate the Sprite3D to face the camera's position
		enemy_health_display.look_at(camera.global_transform.origin, Vector3.UP)
	
	# the enemy always looks at the player so an angle check is not needed
	if nav.distance_to_target() <= ENEMY_WEAPON_FORWARD_RANGE and attack_ready:
		attack_ready = false
		timer.start()
		player_health_bar.value -= 1 


func _unhandled_input(event):
	if Input.is_action_just_pressed("attack"):
		# attack animatie
		var angle_from_player_2_enemy = Global.get_angle_to(player, self)
		var distance_2_player = (position - player.position).length()
		if distance_2_player < player.WEAPON_FORWARD_RANGE and angle_from_player_2_enemy < deg_to_rad(player.WEAPON_ANGLE_RANGE):
			# hit sound effect
			if health > health_bar.min_value:
				for n in 10:
					health -= 1
					health_bar.value = health
					await get_tree().create_timer(0.01).timeout
				if health <= health_bar.min_value:
					Global.amount_of_enemies -= 1
					%cash.change_cash(3)
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
	nav.target_position = player.position
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

func _on_timer_timeout():
	attack_ready = true
