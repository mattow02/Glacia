extends Node2D




# Retourne à la scène principale depuis le menu options
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
