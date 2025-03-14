extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var player: CharacterBody3D = $"../Player"
@onready var game_manager: Node	 = $"../../game_manager"
@onready var interact_cooldown = $"interact cooldown"

#var speed = player.speed
const SPEED: int = 5
const ACCELERATION: int = 20
const INTERACT_RANGE: int = 2
var direction: Vector3 = Vector3.ZERO
var is_following: bool = false
signal freed

func _unhandled_input(_event):
	if not is_following and Input.is_action_just_pressed("interact") and (position - player.position).length() < INTERACT_RANGE:
		player.interacting = true
		is_following = true
		game_manager.is_vilager_free = true
		interact_cooldown.start()
		freed.emit()
		print("I've been freed")

func _physics_process(delta):
	if is_following:
		nav.target_position = player.position
		look_at(Vector3(player.position.x, position.y, player.position.z)) #player_xz_pos
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
	else:
		direction = Vector3.ZERO
	
	if is_on_floor():
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
		if 0 < velocity.y and velocity.y < 0.2:
			velocity.y = 0
	else:
		velocity += get_gravity() * delta
	
	move_and_slide()

func _on_interact_cooldown_timeout():
	player.interacting = false
