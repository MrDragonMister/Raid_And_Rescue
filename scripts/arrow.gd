extends CharacterBody3D

@onready var player: CharacterBody3D = $"../../world_objects/Player"
@onready var inventory: = $"../../gamegui/Inventory"
const THROW_STRENGTH = 20
var is_released: bool = false

func _physics_process(delta):
	if Input.is_action_pressed("interact") and not is_released:
		position = player.position - player.basis.z + 0.5 * player.basis.x
		#position.x = player.position.x + 0 *  0.5 * player.basis.x.x
		position.y = player.position.y + 1.2
		rotation.y = player.rotation.y
		rotation.x = player.active_camera.rotation.x
	if (Input.is_action_just_released("interact") or not inventory.selectslot == 3) and not is_released:
		is_released = true
		player.is_bow_drawn = false
		player.timer.start()
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
		rotation.x = velocity.normalized().y # Pitch
		#rotation.y = velocity.normalized().x  # Yaw
	
	if abs(position.x) > 10000 or abs(position.y) > 10000 or abs(position.z) > 10000:
		queue_free()
		
	move_and_slide()
