extends Node3D

@export var enemy_scene : PackedScene

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn enemy"):
		spawn_enemy(Vector3(randi_range(-10, 10), 0, randi_range(-10, 10)))
	
func spawn_enemy(pos):
	var mob = enemy_scene.instantiate()
	Global.set_enemy_spawn_pos(pos)
	add_child(mob)
	Global.change_amount_of_enemies(1)
