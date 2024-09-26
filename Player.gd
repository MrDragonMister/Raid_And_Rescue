extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003

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
	var direction = Vector3()
	var forward = -cameraf.global_transform.basis.z
	var right = cameraf.transform.basis.x
	
	if Input.is_action_pressed("ui_up"):
		direction += forward
	if Input.is_action_pressed("ui_down"):
		direction -= forward
	if Input.is_action_pressed("ui_left"):
		direction -= right
	if Input.is_action_pressed("ui_right"):
		direction += right
		
	if Input.is_action_pressed("ui_page_up"):
		direction.y += 1
	if Input.is_action_pressed("ui_page_down"):
		direction.y -= 1
		
	if direction.length() > 0:
		direction = direction.normalized() * freecam_speed * delta
		cameraf.position += direction

#turn cameras
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if active_camera == camera1:
			active_camera.rotate_x(-event.relative.y * SENSITIVITY)
			active_camera.rotation.x = clamp(active_camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
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
	

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor() and not active_camera == cameraf:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction: Vector3 = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if not active_camera == cameraf:
		if direction.length() > 0:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
