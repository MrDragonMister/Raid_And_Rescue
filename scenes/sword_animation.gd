extends AnimationPlayer

func _unhandled_input(_event):
	if Input.is_action_just_pressed("attack"):
		play("swing")
