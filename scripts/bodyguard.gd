extends CharacterBody3D

# @onready var Sword_animation = $Shortsword/Sword_animation
@onready var enemy_animation: AnimationPlayer = $Wachter_zwaard_texture2/Enemy_animation
@onready var health_bar: ProgressBar = $"SubViewport/Control/enemy_health_bar"
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var enemy_health_display: Sprite3D = $health_display
@onready var enemy_manager: Node3D = $".."
@onready var player: CharacterBody3D = $"../../Player"
@onready var timer: Timer = $attack_cooldown
@onready var player_health_bar: ProgressBar = $"../../../gamegui/health_bar"
@onready var home_position: Vector3 = Global.enemy_spawn_pos
@onready var slash1: AudioStreamPlayer = $sounds/slash1
@onready var slash2: AudioStreamPlayer = $sounds/slash2
@onready var slash3: AudioStreamPlayer = $sounds/slash3
@onready var slash4: AudioStreamPlayer = $sounds/slash4
@onready var hurt: AudioStreamPlayer = $sounds/dmge
@onready var miss: AudioStreamPlayer = $sounds/miss
@onready var arrow_hit_ding: AudioStreamPlayer = $"sounds/Ding-101377"


const SPEED: int = 3
const ACCELERATION: int = 10
const ENEMY_WEAPON_FORWARD_RANGE: int = 2
const PLAYER_SEEKING_RANGE: int = 15

var health : int = 100
var attack_ready: bool = true
var direction: Vector3 = Vector3.ZERO
var going_to_home_pos: bool = true

func slash_play():
	var sound: Array = [slash1, slash2, slash3, slash4]
	sound[randi_range(0, 3)].play() # Chooses and plays one of the 4 sounds 

func _ready():
	health_bar.value = health
	position = Global.enemy_spawn_pos

func _process(_delta: float) -> void:
	# Get the camera from the current viewport
	var camera = get_viewport().get_camera_3d()
	if camera:
		# Rotate the Sprite3D to face the camera's position
		enemy_health_display.look_at(camera.global_transform.origin, Vector3.UP)
	
	# This needs to be in process if the code is 'is_action_pressed' so it's checked every frame
	# 'is_action_JUST_pressed' is more efficient since it can be put in unhandled input, which isn't checked every frame
	if Input.is_action_just_pressed("attack") and player.attack_ready:
		var angle_from_player_2_enemy = Global.get_angle_to(player, self)
		var distance_2_player = (position - player.position).length()
		if distance_2_player < player.weapon_forward_range and angle_from_player_2_enemy < deg_to_rad(player.weapon_angle_range) and not player.inventory.selectslot == 3:
			slash_play()
			Global.should_play_miss = false
			take_damage(10, player.inventory.selectslot)
		elif not player.inventory.selectslot == 3:
			await get_tree().create_timer(get_process_delta_time()).timeout
			if Global.should_play_miss:
				miss.play()

func _unhandled_input(_envent):
	if Input.is_action_just_released("attack"):
		Global.should_play_miss = true

func _physics_process(delta: float) -> void:
	# Attacking
	# the enemy always looks at the player so an angle check is not needed
	if attack_ready and not going_to_home_pos and (position - player.position).length() <= ENEMY_WEAPON_FORWARD_RANGE:
		attack_ready = false
		enemy_animation.attack()
		timer.start()
		await get_tree().create_timer(0.5).timeout
		if nav.distance_to_target() <= ENEMY_WEAPON_FORWARD_RANGE:
			hurt.play()
			player_health_bar.value -= 5 * (1 - player.armor_damage_reduction)
			player_health_bar.update_health_bar_text()
		
	# Going back home
	if (position - player.position).length() > PLAYER_SEEKING_RANGE: # distance to player
		nav.target_position = home_position
		going_to_home_pos = true
		if position != Vector3(home_position.x, position.y, home_position.z ):
			look_at(Vector3(home_position.x, position.y, home_position.z ))
	else:
		nav.target_position = player.position
		going_to_home_pos = false
		look_at(Vector3(player.position.x, position.y, player.position.z)) #player_xz_pos
		# position.y is used so the enemy always looks straight ahead
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	if is_on_floor():
		if going_to_home_pos and (position - home_position).length() < 1:
			 # Without this the enemy will jump in place
			velocity = Vector3.ZERO
		else:
			velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
		if not going_to_home_pos and nav.distance_to_target() < 1:
			velocity = Vector3.ZERO
	else:
		# Add the gravity.
		velocity += get_gravity() * delta * 2
	
	# Getting hurt by arrows
	for index in range(get_slide_collision_count()):
		if is_instance_id_valid(get_slide_collision(index).get_collider_id()):
			var collision = get_slide_collision(index)
			if not collision == null:
				if collision.get_collider().is_in_group("arrow"):
					collision.get_collider().remove_from_group("arrow")
					# Removing the arrow from it's group makes it so that multiple collisions
					# during the same physics frame don't hurt the enemy multiple times from
					# the same arrow.
					if not collision.get_collider().is_released:
						player.is_bow_drawn = false
						player.timer.start()
					arrow_hit_ding.play()
					collision.get_collider().queue_free()
					take_damage(10, 3)
	
	move_and_slide()

func take_damage(amount_of_damage, weapon):
	var weapon_damage_multiplier_level = Global.inventory[weapon - 1 ]["Level"]
	for i in amount_of_damage * weapon_damage_multiplier_level:
		health -= 1
		health_bar.value = health
		if i % weapon_damage_multiplier_level == 0:
			await get_tree().create_timer(0.01).timeout
		if health <= health_bar.min_value:
			enemy_manager.bodyguard_die()
			queue_free()

func _on_attack_cooldown_timeout():
	attack_ready = true
