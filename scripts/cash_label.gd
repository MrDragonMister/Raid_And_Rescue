extends Label

var cash: int = 100  # Startbedrag

# Functie om het geld bij te werken
func set_cash(new_amount: int):
	cash = new_amount
	text = "Cash: %d" % cash
