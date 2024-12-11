extends Label

func change_gold(change):
	Global.gold += change
	text = "Gold: %d" % Global.gold
