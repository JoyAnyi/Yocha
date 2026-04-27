extends Control

@onready var change = $HBoxContainer/CardAba/AbaLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_button_pressed():
	change.text = "LOADING..."
	await get_tree().create_timer(1.5).timeout
	# This jumps from the Menu right into the game
	get_tree().change_scene_to_file("res://Yocha/AbaWomenSim/Scenes/MainGame.tscn")
