extends AnimationPlayer

@onready var player = $world_objects/Player

func _unhandled_input(event):
	if Input.is_action_just_pressed("attack"):
		play("swing")
