extends Node
class_name PlayerStats

# SIGNALS: The radio system in Godot
# Instead of the Player updating the UI directly, it just shout "Stats Changed!"
# The UI listens for this shout and update itself.
signal stats_updated
#Starting money
var money: int = 100000
var risk: int = 0
var influence: int = 50
var stability: int = 50
#Starting inventory count
var goods: int = 0
var inventory = {
	"palm_oil": 0,
	"garri": 0,
	"salt": 0
}
#The most goods you can carry
var max_inventory: int = 100
#Game Memory
var choice_history: Array = []
#Call this function when the user buys or sells things
func update_money(amount: int):
	money+=amount
	stats_updated.emit()
	
func update_risk(amount: int):
	risk += amount
	risk = clamp(risk, 0, 100)
	stats_updated.emit()

# Call this function when we get or lose stock.
func update_goods(amount: int):
	goods += amount
	
# CLAMP is a helper math function. It ensures goods never goes below 0 or above 100
	goods = clamp(goods, 0, max_inventory)
	stats_updated.emit()
	
# A boolean helper to check if we can afford something
func has_goods(amount: int)-> bool:
	if goods >= amount:
		return true
	else:
			return false
			
func change_inventory(item: String, amount: int) -> void:
	if not inventory.has(item):
		inventory[item] = 0
	inventory[item] += amount
	inventory[item] = max(inventory[item], 0)  # Prevent negative quantities

	# Update total goods for UI grid
	goods = 0
	for key in inventory.keys():
		goods += inventory[key]
	stats_updated.emit()
	
func record_choice(event_title: String, choice_made: String):
	choice_history.append({
		"event": event_title,
		"choice": choice_made
	})

func update_influence(amount: int):
	influence += amount
	influence = clamp(influence, 0, 100)
	stats_updated.emit()

func update_stability(amount: int):
	stability += amount
	stability = clamp(stability, 0, 100)
	stats_updated.emit()
