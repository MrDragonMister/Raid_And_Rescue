extends Label

func change_coins(change: int):
	Global.gold += change
	text = "Gold: %d" % Global.gold
