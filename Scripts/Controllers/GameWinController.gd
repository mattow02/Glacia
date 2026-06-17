extends Node2D

@onready var score_label: Label = $ScoreLabel

func _ready() -> void:
	score_label.add_theme_color_override("font_color", Color.BLACK)
	score_label.add_theme_font_size_override("font_size", 20)
	jouer_video_avec_delai_son()
	afficher_resultats()


func afficher_resultats() -> void:
	var stats = GameData.stats_fin_de_partie

	if stats.is_empty():
		score_label.text = "No game data available."
		return

	var texte = "CONGRATULATIONS — MISSION COMPLETE!\n\n"
	texte += "Final Score: " + str(stats.score_total) + " pts\n"
	texte += "—————————————\n"
	texte += "Remaining funds: " + str(stats.argent_restant) + " €\n"
	texte += "Total invested: " + str(stats.argent_depense) + " €\n\n"

	texte += "Surviving Buildings (" + str(stats.liste_survivants.size()) + ")\n"
	if stats.liste_survivants.size() > 0:
		for nom_bat in stats.liste_survivants:
			texte += "  + " + nom_bat + "\n"
	else:
		texte += "  None... That was close!\n"

	texte += "\nDestroyed Buildings (" + str(stats.liste_detruits.size()) + ")\n"
	if stats.liste_detruits.size() > 0:
		for nom_bat in stats.liste_detruits:
			texte += "  - " + nom_bat + "\n"
	else:
		texte += "  None — perfect management!\n"

	score_label.text = texte


func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/GameLevel.tscn")


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")


func _on_snipe_finished() -> void:
	$Snipe.visible = false


func _on_screen_crazy_finished() -> void:
	$ScreenCrazy.visible = false


func jouer_video_avec_delai_son():
	var video = $snoopdog
	video.volume_db = -80
	video.visible = true
	video.play()
	await get_tree().create_timer(3.0).timeout
	video.volume_db = 0
