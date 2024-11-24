extends Node3D

@export var enemy_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn enemy"):
		spawn_enemy(0)
	
func spawn_enemy(position):
	var mob = enemy_scene.instantiate()
	add_child(mob)
