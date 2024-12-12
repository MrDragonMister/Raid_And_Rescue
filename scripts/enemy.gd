extends CharacterBody3D

const ENEMY_SPEED = 3
const ENEMY_WEAPON_FORWARD_RANGE = 1

var health : int = 100
var attack_ready: bool = true
var direction: Vector3 = Vector3.ZERO

@onready var enemy_animation = $Wachter_zwaard_animated3/enemy_animation
@onready var health_bar: = $"SubViewport/Control/enemy_health_bar"
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var enemy_health_display := $health_display
@onready var enemy_manager = $".."
@onready var player = $"../../Player"
@onready var game_manager = %game_manager
@onready var timer: Timer = $attack_cooldown
@onready var player_health_bar = $"../../../gamegui/health_bar"
@onready var slash1 = $slash1
@onready var slash2 = $slash2
@onready var slash3 = $slash3
@onready var slash4 = $slash4
@onready var explosion = $explosion
@onready var miss = $miss


func _ready():
	health_bar.value = health
	position = Global.enemy_spawn_pos

func _process(_delta: float) -> void:
	# Get the camera from the current viewport
	var camera = get_viewport().get_camera_3d()
	if camera:
		# Rotate the Sprite3D to face the camera's position
		enemy_health_display.look_at(camera.global_transform.origin, Vector3.UP)
	
	# the enemy always looks at the player so an angle check is not needed

	if attack_ready and nav.target_position == player.position and nav.distance_to_target() <= ENEMY_WEAPON_FORWARD_RANGE:
		enemy_animation.attack()
		attack_ready = false
		timer.start()
		player_health_bar.value -= 1


func _unhandled_input(_envent):
	if Input.is_action_just_pressed("attack"):
		# attack animatie
		var angle_from_player_2_enemy = Global.get_angle_to(player, self)
		var distance_2_player = (position - player.position).length()
		if distance_2_player < player.WEAPON_FORWARD_RANGE and angle_from_player_2_enemy < deg_to_rad(player.WEAPON_ANGLE_RANGE):
			play_random_sound()
			if health > health_bar.min_value:
				for n in 10:
					health -= 1
					health_bar.value = health
					await get_tree().create_timer(0.01).timeout
				if health <= health_bar.min_value:
					explosion.play()
					self.visible = false
					await _wait_for_player_to_finish(explosion)
					enemy_manager.enemy_die()
					queue_free()
		else:
			miss.play()
			pass

func _wait_for_player_to_finish(player: AudioStreamPlayer) -> void:
	while player.playing:
		await get_tree().create_timer(0.1).timeout

	"""
	if Input.is_action_just_pressed("interact"):
		if health < health_bar.max_value:aa
			for n in 10:
				health += 1
				health_bar.value = health
				await get_tree().create_timer(0.01).timeout
	"""

func play_random_sound():
	print("play sound")
	var random_number = randi_range(1, 4)  # Genereer een willekeurig getal tussen 1 en 4
	
	var selected_player : AudioStreamPlayer = null  # Zorg ervoor dat dit een AudioStreamPlayer is
	print(random_number)
	if random_number == 1:
		selected_player = slash1
	elif random_number == 2:
		selected_player = slash2
	elif random_number == 3:
		selected_player = slash3
	elif random_number == 4:
		selected_player = slash4

	# Controleer of selected_player daadwerkelijk een AudioStreamPlayer is
	if selected_player != null:
		selected_player.play()  # Speel het geluid af
	else:
		print("Fout: selected_player is null, controleer de naam van de nodes.")


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
