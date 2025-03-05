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
	if Input.is_action_just_released("interact"):
		is_released = true
		velocity = player.velocity + (position - player.position) * THROW_STRENGTH
		velocity *= 1 - abs(clamp(player.active_camera.rotation.x * 2 / PI, -1, 1))
		velocity.y = ((position - player.position) * THROW_STRENGTH).length() * (clamp(player.active_camera.rotation.x * 2 / PI, -1, 1))
	
	if is_on_ceiling() or is_on_wall() or is_on_floor():
		velocity = Vector3.ZERO
	elif is_released:
		velocity += get_gravity() * delta
		velocity = velocity.lerp(Vector3.ZERO, delta * 0.1)
		var vel_norm = velocity.normalized()
		rotation.x = vel_norm.y
		
	#print(player.player.active_camera.rotation.x, " ", player.rotation.y)
	#	print(player.rotation)
	move_and_slide()
	
