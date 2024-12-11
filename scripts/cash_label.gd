extends Label

func change_coins(change: int):
	Global.gold += change
	text = "Cash: %d" % Global.gold
