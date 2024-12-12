extends AnimationPlayer

@onready var player = $"../.."

func _process(_delta: float) -> void:
	if player.velocity.length() > 2:
		play("Walking")
	else:
		stop()
