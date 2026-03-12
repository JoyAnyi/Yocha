#Resource: Tells Godot this is not a character or a sound, it is a data container, it saves memory and makes it easy to save or load
extends Resource
class_name HistoricalEvent

# DESCRIPTION: What the player sees.
#@export: This is the bridge between code and editor. Without @export, this variable is invisible.
#@export_group("Content")
@export var title: String = "Event Title"
@export_multiline var description: String = "What happened?"

# Texture2D: For images management.
@export var event_image: Texture2D
# AudioStream for voiceovers/SFX
@export var event_audio: AudioStream

# DATA: How the game changes:
#@export_group("Game Data")
# If 1.0, prices are normal. If 2.0, prices double.
@export var price_multiplier: float = 1.0
#To track how dangerous the streets are.
@export var risk_level: int = 0
#Helps distinguish Story vs Shop events.
@export var type: String = "trade"

# CHOICES: What the player can do
@export var option_a_text: String =" "  #"Buy Goods"
@export var option_b_text: String = " "  # "Stay Home"

# CONSEQUENCES: The Logic of the Run
#@export_group("Option A Consequences")
#@export var option_a_money_change: int = 0
#@export var option_a_goods_change: int = 0
#@export var option_a_risk_change: int = 0
#
#@export_group("Option B Consequences")
#@export var option_b_money_change: int = 0
#@export var option_b_goods_change: int = 0
#@export var option_b_risk_change: int = 0


@export_group("Option A Trade Data")
@export var option_a_good_name: String = ""
@export var option_a_quantity: int = 0
@export var option_a_is_buy: bool = true
@export var option_a_risk_change: int = 0
#@export var option_a_unrest_change: int = 0

@export_group("Option B Trade Data")
@export var option_b_good_name: String = ""
@export var option_b_quantity: int = 0
@export var option_b_is_buy: bool = true
@export var option_b_risk_change: int = 0
#@export var option_b_unrest_change: int = 0
