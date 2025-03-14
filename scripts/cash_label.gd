extends Label

func _ready():
	text = "Gold: %d" % Global.gold
	
func change_coins(change: int):
	Global.gold += change
	text = "Gold: %d" % Global.gold
