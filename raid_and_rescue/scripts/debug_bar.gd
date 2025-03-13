extends ProgressBar

@onready var health_bar_text: RichTextLabel = $RichTextLabel

func _ready():
	max_value = 200
	update_debug_bar()

func update_debug_bar():
	health_bar_text.clear()
	health_bar_text.append_text(str(self.value))
