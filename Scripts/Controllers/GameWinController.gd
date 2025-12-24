extends Node2D

@onready var score_label: Label = $ScoreLabel

# Prépare le label et affiche les résultats de victoire
func _ready() -> void:
	# --- STYLE DU TEXTE ---
	score_label.add_theme_color_override("font_color", Color.BLACK) # Texte en NOIR
	score_label.add_theme_font_size_override("font_size", 20)       # Taille 25
	jouer_video_avec_delai_son()
	
	afficher_resultats()

# Construit le texte de score victoire à partir des stats finales
func afficher_resultats() -> void:
	var stats = GameData.stats_fin_de_partie
	
	if stats.is_empty():
		score_label.text = "Aucune donnée de partie."
		return

	# J'ai retiré les balises [b] car si c'est un Label standard, elles s'affichent en texte brut.
	var texte = "FELICITATIONS ! MISSION REUSSI !\n\n"
	
	texte += "Score Final : " + str(stats.score_total) + " pts\n"
	texte += "----\n"
	texte += "Argent restant : " + str(stats.argent_restant) + "€\n"
	texte += "Argent investi : " + str(stats.argent_depense) + "€\n\n"
	
	texte += "--- Batiments Survivants (" + str(stats.liste_survivants.size()) + ") ---\n"
	if stats.liste_survivants.size() > 0:
		for nom_bat in stats.liste_survivants:
			texte += "+ " + nom_bat + "\n"
	else:
		texte += "Aucun... C'etait moins une !\n"
	
	texte += "\n--- Batiments Detruits (" + str(stats.liste_detruits.size()) + ") ---\n"
	if stats.liste_detruits.size() > 0:
		for nom_bat in stats.liste_detruits:
			texte += "- " + nom_bat + "\n"
	else:
		texte += "Aucun ! Gestion parfaite !\n"

	score_label.text = texte


# Relance une partie
func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/GameLevel.tscn")


# Retourne au menu principal
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
