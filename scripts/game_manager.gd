extends Node

@onready var health := 10
@onready var health_bar := $"../Control/health_bar"
@onready var enemy_health_display := $"../world_objects/Characters/Enemy/health_display"

func _ready():
	health_bar.value = health	
	
func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("attack"):
		#for n in 10:
			#health = max(health - 1, health_bar.min_value)
			#health_bar.value = health
			#await get_tree().create_timer(0.01).timeout
	#if Input.is_action_just_pressed("interact"):
		#for n in 10:
			#health = min(health + 1, health_bar.max_value)
			#health_bar.value = health
			#await get_tree().create_timer(0.01).timeout
		
	# Get the camera from the current viewport
	var camera = get_viewport().get_camera_3d()
	if camera:
		# Rotate the Sprite3D to face the camera's position
		enemy_health_display.look_at(camera.global_transform.origin, Vector3.UP)
