extends ProgressBar

@onready var health_bar_text: RichTextLabel = $RichTextLabel

func _ready():
	update_health_bar_text()

func _process(_delta):
	#self.value = Global.amount_of_enemies
	pass
	
func update_health_bar_text():
	health_bar_text.clear()
	health_bar_text.append_text("[center]Health:   %s/%s" % [self.value, self.max_value])
