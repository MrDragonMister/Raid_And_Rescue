extends CharacterBody3D

# player testing needed
# sfx en in de toekomst mischien nog particles nodig om duidelijk te maken of je raakt of niet
@export var WEAPON_ANGLE_RANGE: float = 45 # nu nog in graden voor testen, later in rad voor optimalisatie
@export var WEAPON_FORWARD_RANGE: float = 2

const SPEED: int = 5
const JUMP_VELOCITY: int = 7
const SENSITIVITY: float = 0.003
const AIR_SPEED: float = 3
const JUMP_XZ_ACCELERATION: float = 1.2
const FREECAM_SPEED: int = 10
const FREECAM_SENSITIVITY: float = 0.25

#headbob variables
const BOB_FREQ: int = 2
const BOB_AMP: float = 0.02
var t_bob = 0.0

var active_camera: Camera3D
var attack_ready: bool = true
var shoot_ready: bool = true
var armor_damage_reduction: float = 0 # percentage of base damage, between 0 and 1
# TODO ^wouldn't directly storing the amount the enemy can damage be more efficient?

@onready var player: CharacterBody3D = $"."
@onready var head: Node3D = $Head
@onready var campoint: Node3D = $Head/Campoint
@onready var enemy: CharacterBody3D  = $"../Enemy_manager/Enemy"
@onready var timer: Timer = $Attack_cooldown
@onready var camera1: Camera3D = $Head/Camera3D				#first person
@onready var camera2: Camera3D = $Head/Campoint/Camera3D2 	#third person
@onready var cameraf: Camera3D = $Head/Camera3DF			#freecam
@onready var miss: AudioStreamPlayer = $sounds/miss
@onready var debug_bar: = $"../../gamegui/debug_bar"
@onready var game_manager: Node = $"../../game_manager"
@onready var arrow_scene: PackedScene = preload("res://scenes/arrow.tscn")

func _ready() -> void:
	#reset camera
	active_camera = camera1
	camera1.current = true
	camera2.current = false
	cameraf.current = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _process(delta: float) -> void:
	#switch camera input
	if Input.is_action_just_pressed("switch_camera"):
		toggle_camera()
	if Input.is_action_just_pressed("freecam"):
		free_camera()
	if cameraf.current:
		freecam_movement(delta)
	
	# This needs to be in process if the code is 'is_action_pressed' so it's checked every frame
	# 'is_action_JUST_pressed' is more efficient since it can be put in unhandled input, which isn't checked every frame
	if Input.is_action_just_pressed("attack") and attack_ready:
		timer.start()
		$Shortsword/Player_sword_animation.stop()
		$Shortsword/Player_sword_animation.play("swing")
		$Axe_Final/Axe_animation.play("Axe_swing")
		if Global.amount_of_enemies == 0:
			# If there are enemies, they will handle the sound
			miss.play()
		await get_tree().create_timer(get_process_delta_time()).timeout
		attack_ready = false
	
	if Input.is_action_just_pressed("interact") and shoot_ready and attack_ready: # and bow_is_in_hand
		game_manager.spawn_arrow()
		timer.start()
		attack_ready = false

#toggle between 1st and 3rd camera
func toggle_camera():
	if not active_camera == cameraf:
		camera1.current = active_camera == camera2	# toggle what camera is true
		camera2.current = active_camera != camera2
		if active_camera == camera1:
			active_camera = camera2
		else:	
			active_camera = camera1

#activate freecam
func free_camera():
	pass
	"""
	camera1.current = active_camera == cameraf # toggle what camera is true
	cameraf.current = active_camera != cameraf
	if active_camera == cameraf:
		active_camera = camera1
	else:
		cameraf.transform.origin = player.global_transform.origin	# TODO Deze 2 regels moeten beter werken
		cameraf.rotation_degrees = player.rotation_degrees
		active_camera = cameraf	
	camera2.current = false		# waarom weet ik niet, maar zonder deze regel loopt een enemy niet als je er op staat
	"""

#freecam movement
func freecam_movement(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	
	#get forward and right directions
	var right = cameraf.transform.basis.x.normalized()
	var forward = cameraf.transform.basis.z
	forward.y = 0  # Ignore vertical component
	forward = forward.normalized()
	
	#calculate XZ movement
	var direction: Vector3 = right * input_dir.x + forward * input_dir.y
	
	#vertical movement
	if Input.is_action_pressed("jump"):
		direction.y += 1
	if Input.is_action_pressed("crouch"):
		direction.y -= 1
		
	#apply movement
	if direction.length() > 0:
		direction = direction.normalized() * FREECAM_SPEED * delta
		cameraf.position += direction

func _unhandled_input(event: InputEvent) -> void:
	#turn cameras
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if active_camera == camera1:
			active_camera.rotate_x(-event.relative.y * SENSITIVITY)
			active_camera.rotation.x = clamp(active_camera.rotation.x, -PI/2, PI/2)
			player.rotate_y(-event.relative.x * SENSITIVITY)
		elif active_camera == camera2:
			campoint.rotate_x(-event.relative.y * SENSITIVITY)
			campoint.rotation.x = clamp(campoint.rotation.x, -PI/4, PI/2)
			player.rotate_y(-event.relative.x * SENSITIVITY)
		elif active_camera == cameraf: # TODO werkt niet
			rotation = cameraf.rotation_degrees
			rotation.x -= event.relative.y * FREECAM_SENSITIVITY
			rotation.x = clamp(rotation.x, -89, 89)
			rotation.y -= event.relative.x * FREECAM_SENSITIVITY
			cameraf.rotation_degrees = Vector3(rotation.x, rotation.y, 0)

#player movement
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * 2 * delta 
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var direction: Vector3 = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if not active_camera == cameraf:
		if direction.length() > 0:
			if is_on_floor():
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				# needs player testing
				velocity.x = move_toward(velocity.x, direction.x * AIR_SPEED, delta)
				velocity.z = move_toward(velocity.z, direction.z * AIR_SPEED, delta)
		else:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		velocity = Vector3.ZERO

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor() and not active_camera == cameraf:
		velocity.y = JUMP_VELOCITY
		velocity.x *= JUMP_XZ_ACCELERATION
		velocity.z *= JUMP_XZ_ACCELERATION 
		
	move_and_slide()
	
	# head bobbing
	if is_on_floor():
		t_bob += delta * velocity.length()
		camera1.transform.origin = headbob(t_bob)
	else:
		camera1.transform.origin = Vector3(0, 0.3, 0) # headbob(0)

#head bobbing
func headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = BOB_AMP * sin(time * BOB_FREQ) + 0.3
	return pos

func _on_attack_cooldown_timeout():
	attack_ready = true
