extends CharacterBody3D

const ENEMY_SPEED = 5
@onready var enemy: CharacterBody3D = $"."
@onready var health := 100
@onready var health_bar := $"SubViewport/Control/enemy_health_bar"

func _physics_process(delta: float) -> void:
	var want_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction: Vector3 = (enemy.transform.basis * Vector3(want_dir.x, 0, want_dir.y)).normalized()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2

	# Get the input direction and handle the movement/deceleration.
	if is_on_floor():
		velocity.x = direction.x * ENEMY_SPEED
		velocity.z = direction.z * ENEMY_SPEED
		
	move_and_slide()
	
func _ready():
	health_bar.value = health	
	
func _process(delta: float) -> void:
	var player = get_node("../Player")
	var player_position = player.global_transform.origin
	var enemy_position = global_transform.origin
	var playerdir_to_enemy = player.direction_to(enemy)
	var playerinput_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var playerdir: Vector3 = (player.transform.basis * Vector3(playerinput_dir.x, 0, playerinput_dir.y)).normalized()
	if Input.is_action_just_pressed("attack"):
		if enemy_position.distance_to(player_position) <= 3:
			if playerdir_to_enemy.dot(playerdir):
				for n in 10:
					health = max(health - 1, health_bar.min_value)
					health_bar.value = health
					await get_tree().create_timer(0.01).timeout
	if Input.is_action_just_pressed("interact"):
		for n in 10:
			health = min(health + 1, health_bar.max_value)
			health_bar.value = health
			await get_tree().create_timer(0.01).timeout
