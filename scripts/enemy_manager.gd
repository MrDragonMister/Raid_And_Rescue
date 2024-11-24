extends Node3D

@export var enemy_scene : PackedScene

#@onready var spawn_pos = Vector3.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn enemy"):
		spawn_enemy()
	
func spawn_enemy():
	var mob = enemy_scene.instantiate()
	#spawn_pos = position
	add_child(mob)
	
