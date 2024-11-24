extends CharacterBody3D

const ENEMY_SPEED = 3
@onready var enemy: CharacterBody3D = $"."
@onready var health := 100
@onready var health_bar := $"SubViewport/Control/enemy_health_bar"
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var enemy_health_display := $health_display


func _ready():
	health_bar.value = health	

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
