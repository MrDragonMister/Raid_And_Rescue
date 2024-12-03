extends Node3D

@export var enemy_scene : PackedScene

var enemy_spawnpos = Vector3(10, 10, 10)

func _init():
	enemy_spawnpos = Vector3(0, 1, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn enemy"):
		spawn_enemy(Vector3(10, 10, 10))
	
func spawn_enemy(pos):
	var mob = enemy_scene.instantiate()
	print("manager a", enemy_spawnpos)
	#enemy_spawnpos = pos
	print("manager b", enemy_spawnpos)
	add_child(mob)
