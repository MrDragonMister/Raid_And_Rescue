extends AnimationPlayer

@onready var villager = $"../.."

func _process(_delta: float) -> void:
	if not is_playing() and villager.velocity.length() > 2:
		play("Walking")
