extends CharacterBody3D

const ENEMY_SPEED = 5
@onready var enemy: CharacterBody3D = $"."

func _physics_process(delta: float) -> void:
	var want_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction: Vector3 = (enemy.transform.basis * Vector3(want_dir.x, 0, want_dir.y)).normalized()
	
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta * 2

	# Get the input direction and handle the movement/deceleration.
	if is_on_floor():
		velocity.x = direction.x * ENEMY_SPEED
		velocity.z = direction.z * ENEMY_SPEED
		
	move_and_slide()
