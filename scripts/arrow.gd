extends CharacterBody3D

@onready var player: CharacterBody3D = $"../../world_objects/Player"
const THROW_STRENGTH = 20
var is_released: bool = false

func _physics_process(delta):
	if Input.is_action_pressed("interact") and not is_released:
		position = player.position - player.basis.z
		position.y = player.position.y + 1.5 - player.basis.z.y
		rotation.y = player.rotation.y
		rotation.x = player.active_camera.rotation.x
	if Input.is_action_just_released("interact") and not is_released:
		is_released = true
		velocity = player.velocity + -player.basis.z * THROW_STRENGTH
		# player velocity + direction player is looking
		
		#velocity *= 1 - abs(clamp(player.active_camera.rotation.x * 2 / PI, -1, 1))
		# Why is this^ here? (vraag van Milan aan Milan)
		
		# Changes the upwards velocity based on how much the player is looking up or down
		velocity.y = (-player.basis.z * THROW_STRENGTH).length() * (clamp(player.active_camera.rotation.x * 2 / PI, -1, 1))
	
	if is_on_ceiling() or is_on_wall() or is_on_floor():
		velocity = Vector3.ZERO
		remove_from_group("arrow")
	elif is_released:
		velocity += get_gravity() * delta
		velocity = velocity.lerp(Vector3.ZERO, delta * 0.1)
		rotation.x = velocity.normalized().y
	
	move_and_slide()
