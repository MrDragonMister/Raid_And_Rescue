extends ProgressBar

@onready var health_bar = $"."
@onready var enemy_manager = %Enemy_manager

func _process(delta):
	health_bar.value = Global.amount_of_enemies
