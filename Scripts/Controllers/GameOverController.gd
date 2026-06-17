extends Node2D

@onready var score_label: Label = $ScoreLabel

func _ready() -> void:
	score_label.add_theme_color_override("font_color", Color.BLACK)
	score_label.add_theme_font_size_override("font_size", 20)
	afficher_resultats()


func afficher_resultats() -> void:
	var stats = GameData.stats_fin_de_partie

	if stats.is_empty():
		score_label.text = "No game data available."
		return

	var texte = "GAME OVER — THE STATION HAS FROZEN\n\n"
	texte += "Final Score: " + str(stats.score_total) + " pts\n"
	texte += "—————————————\n"
	texte += "Months survived: " + str(stats.tours_tenus) + "\n"
	texte += "Remaining funds: " + str(stats.argent_restant) + " €\n"
	texte += "Total invested: " + str(stats.argent_depense) + " €\n\n"

	texte += "Surviving Buildings (" + str(stats.liste_survivants.size()) + ")\n"
	if stats.liste_survivants.size() > 0:
		for nom_bat in stats.liste_survivants:
			texte += "  + " + nom_bat + "\n"
	else:
		texte += "  None... Total loss.\n"

	texte += "\nDestroyed Buildings (" + str(stats.liste_detruits.size()) + ")\n"
	if stats.liste_detruits.size() > 0:
		for nom_bat in stats.liste_detruits:
			texte += "  - " + nom_bat + "\n"
	else:
		texte += "  None (survival bar dropped to zero)\n"

	score_label.text = texte


func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/GameLevel.tscn")


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")
