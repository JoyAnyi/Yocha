extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_start_button_pressed():
	# This jumps from the Menu right into the game
	get_tree().change_scene_to_file("res://Yocha/AbaWomenSim/Scenes/story_selection.tscn")


func _on_quit_button_pressed():
	# This safely closes the application
	get_tree().quit()
