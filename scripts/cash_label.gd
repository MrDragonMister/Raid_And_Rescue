extends Label

@onready var coins: int = Global.gold

func _process(_delta):
	if coins != Global.gold:
		coins = Global.gold
		text = "Cash: %d" % coins
