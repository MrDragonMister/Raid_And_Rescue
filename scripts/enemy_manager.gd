extends Node3D

@export var enemy_scene : PackedScene

#@onready var spawn_pos = Vector3.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn enemy"):
		spawn_enemy(Vector3(10, 10, 10))
	
func spawn_enemy(pos):
	var mob = enemy_scene.instantiate()
	Global.set_enemy_spawnpos(pos)
	add_child(mob)
	
