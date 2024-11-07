extends CharacterBody3D


const SPEED = 5
const JUMP_VELOCITY = 6
const SENSITIVITY = 0.003
const AIR_SPEED = 5
const JUMP_XZ_ACCELERATION = 1.2

#headbob variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.02
var t_bob = 0.0

@onready var player: CharacterBody3D = $"."
@onready var head: Node3D = $Head
@onready var campoint: Node3D = $Head/Campoint

@onready var camera1: Camera3D = $Head/Camera3D				#first person
@onready var camera2: Camera3D = $Head/Campoint/Camera3D2 	#third person
@onready var cameraf: Camera3D = $Head/Camera3DF			#freecam
var active_camera: Camera3D
var freecam_speed = 10.0
var freecam_sensitivity = 0.25


#reset camera
func _ready() -> void:
	active_camera = camera1
	camera1.current = true
	camera2.current = false
	cameraf.current = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
#switch camera input
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch_camera"):
		toggle_camera()
	if Input.is_action_just_pressed("freecam"):
		free_camera()
	if cameraf.current:
		freecam_movement(delta)
	
#toggle between 1st and 3rd camera
func toggle_camera():
	if active_camera == camera1:
		active_camera = camera2
		camera1.current = false
		camera2.current = true
		cameraf.current = false
	else:
		if active_camera == camera2:
			active_camera = camera1
			camera1.current = true
			camera2.current = false
			cameraf.current = false

#activate freecam
func free_camera():
	if not active_camera == cameraf:
		cameraf.transform.origin = player.global_transform.origin
		cameraf.rotation_degrees = player.rotation_degrees
		active_camera = cameraf
		camera1.current = false
		camera2.current = false
		cameraf.current = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		active_camera = camera1
		camera1.current = true
		camera2.current = false
		cameraf.current = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#freecam movement
func freecam_movement(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	
	#get forward direction
	var forward = cameraf.transform.basis.z
	forward.y = 0  # Ignore vertical component
	forward = forward.normalized()
	
	#get right direction
	var right = cameraf.transform.basis.x.normalized()
	
	#calculate movement direction
	var direction: Vector3 = right * input_dir.x + forward * input_dir.y
	
	#vertical movement
	if Input.is_action_pressed("jump"):
		direction.y += 1
	if Input.is_action_pressed("crouch"):
		direction.y -= 1
		
	#apply movement
	if direction.length() > 0:
		direction = direction.normalized() * freecam_speed * delta
		cameraf.position += direction

#turn cameras
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if active_camera == camera1:
			active_camera.rotate_x(-event.relative.y * SENSITIVITY)
			active_camera.rotation.x = clamp(active_camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
			player.rotate_y(-event.relative.x * SENSITIVITY)
		elif active_camera == camera2:
			campoint.rotate_x(-event.relative.y * SENSITIVITY)
			campoint.rotation.x = clamp(campoint.rotation.x, deg_to_rad(-20), deg_to_rad(20))
			player.rotate_y(-event.relative.x * SENSITIVITY)
		elif active_camera == cameraf:
			var rotation = cameraf.rotation_degrees
			rotation.x -= event.relative.y * freecam_sensitivity
			rotation.x = clamp(rotation.x, -89, 89)
			rotation.y -= event.relative.x * freecam_sensitivity
			cameraf.rotation_degrees = Vector3(rotation.x, rotation.y, 0)

#player movement
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2

	# Get the input direction and handle the movement/deceleration.
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var direction: Vector3 = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if not active_camera == cameraf:
		if direction.length() > 0:
			if is_on_floor():
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				velocity.x = move_toward(velocity.x, direction.x, AIR_SPEED * delta)
				velocity.z = move_toward(velocity.z, direction.z, AIR_SPEED * delta)
		else:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor() and not active_camera == cameraf:
		velocity.y = JUMP_VELOCITY
		
		velocity.x *= JUMP_XZ_ACCELERATION
		velocity.z *= JUMP_XZ_ACCELERATION 
				
	move_and_slide()
	#head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera1.transform.origin = headbob(t_bob)

#head bobbing
func headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = BOB_AMP * sin(time * BOB_FREQ)+0.3
	return pos
	
