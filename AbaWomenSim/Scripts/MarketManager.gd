#extends Node
#
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
extends Node
class_name MarketManager

# Base historical prices (approximate simulation values)
var base_prices = {
	"palm_oil": 300,
	"garri": 200,
	"salt": 100,
}

# Global unrest level (can scale as riot escalates)
var unrest_level: int = 0

func calculate_price(good_name: String, event_multiplier:float, player_risk:int) -> int:
	var base_price = base_prices.get(good_name, 0)
	# Price increases with unrest and risk
	var unrest_modifier = 1.0 + (unrest_level * 0.05)
	var risk_modifier = 1.0 + (player_risk * 0.01)
	var final_price = base_price * event_multiplier * unrest_modifier * risk_modifier
	return int(final_price)
