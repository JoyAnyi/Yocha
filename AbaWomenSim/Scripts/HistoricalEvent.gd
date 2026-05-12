#Resource: Tells Godot this is not a character or a sound, it is a data container, it saves memory and makes it easy to save or load
extends Resource
class_name HistoricalEvent

# DESCRIPTION: What the player sees.
#@export: This is the bridge between code and editor. Without @export, this variable is invisible.
@export var title: String = "Event Title"
@export_multiline var description: String = "What happened?"

# Texture2D: For images management.
@export var event_image: Texture2D
# AudioStream for voiceovers/SFX
@export var event_audio: AudioStream
@export var background_audio: AudioStream

# DATA: How the game changes:
# If 1.0, prices are normal. If 2.0, prices double.
@export var price_multiplier: float = 1.0
#To track how dangerous the streets are.
@export var risk_level: int = 0
#Helps distinguish Story vs Shop events.
#@export var type: String = "trade"
@export_enum("trade", "political", "hybrid")
var type: String = "trade"

# CHOICES: What the player can do
@export var option_a_text: String =" "  
@export var option_b_text: String = " "  

@export_group("Option A Trade Data")
@export var option_a_good_name: String = ""
@export var option_a_quantity: int = 0
@export var option_a_is_buy: bool = true
@export var option_a_risk_change: int = 0

@export_group("Option B Trade Data")
@export var option_b_good_name: String = ""
@export var option_b_quantity: int = 0
@export var option_b_is_buy: bool = true
@export var option_b_risk_change: int = 0

@export_group("Branching Destinations")
@export var next_event_index_a: int = 0
@export var next_event_index_b: int = 0

@export_group("Political Stats")
@export var influence_change_a: int = 0
@export var influence_change_b: int = 0
@export var stability_change_a: int = 0
@export var stability_change_b: int = 0
