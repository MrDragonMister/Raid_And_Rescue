extends Label

func change_cash(change):
	Global.gold += change
	text = "Cash: %d" % Global.gold
