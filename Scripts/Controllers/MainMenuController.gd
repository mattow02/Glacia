extends Node

@onready var game = preload("res://Scenes/UI/Dialogues.tscn")
@onready var game_mode: PanelContainer = $GameMode
@onready var normal: Button = $Normal
@onready var infini: Button = $Infini
@onready var quit: Button = $Quit

# Quitte entièrement le jeu
func _on_btn_exit_pressed() -> void:
	get_tree().quit()

# Affiche le choix de mode de jeu
func _on_btn_play_pressed() -> void:
	game_mode.visible = true
	normal.visible = true
	infini.visible = true
	quit.visible = true

# Ouvre ou ferme la fenêtre des réglages
func _on_btn_settings_pressed() -> void:
	$SettingsWindows.visible = true

# Lance une partie en mode normal
func _on_normal_pressed() -> void:
	GameData.mode_infini = false
	get_tree().change_scene_to_packed(game)

# Lance une partie en mode infini
func _on_infini_pressed() -> void:
	GameData.mode_infini = true
	get_tree().change_scene_to_packed(game)

# Ferme le choix de mode sans lancer de partie
func _on_quit_pressed() -> void:
	game_mode.visible = false
	normal.visible = false
	infini.visible = false
	quit.visible = false


func _on_quit_2_pressed() -> void:
	$SettingsWindows.visible = false	
