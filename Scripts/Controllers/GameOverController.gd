extends Node2D

@onready var score_label: Label = $ScoreLabel 

# Prépare le label et affiche les résultats de défaite
func _ready() -> void:
	# On utilise une taille plus petite (25) pour que tout le texte rentre
	score_label.add_theme_color_override("font_color", Color.BLACK)
	score_label.add_theme_font_size_override("font_size", 20)
	
	afficher_resultats()

# Construit le texte de score Game Over à partir des stats finales
func afficher_resultats() -> void:
	var stats = GameData.stats_fin_de_partie
	
	if stats.is_empty():
		score_label.text = "Aucune donnée de partie."
		return

	# En-tête spécifique à la défaite
	var texte = "GAME OVER - LA STATION A GELE...\n\n"
	
	# Affichage des scores (Même format que la victoire)
	texte += "Score Final : " + str(stats.score_total) + " pts\n"
	texte += "-----------------\n"
	texte += "Tours tenus : " + str(stats.tours_tenus) + " mois\n"
	texte += "Argent restant : " + str(stats.argent_restant) + "€\n"
	texte += "Argent investi : " + str(stats.argent_depense) + "€\n\n"
	
	# Liste des Survivants
	texte += " Batiments Survivants (" + str(stats.liste_survivants.size()) + ") \n"
	if stats.liste_survivants.size() > 0:
		for nom_bat in stats.liste_survivants:
			texte += "+ " + nom_bat + "\n"
	else:
		texte += "Aucun... C'est le neant complet.\n"
	
	# Liste des Détruits
	texte += "\n Batiments Detruits (" + str(stats.liste_detruits.size()) + ") \n"
	if stats.liste_detruits.size() > 0:
		for nom_bat in stats.liste_detruits:
			texte += "- " + nom_bat + "\n"
	else:
		texte += "Aucun (La défaite est due à la barre de survie !)\n"

	score_label.text = texte

# Relance une partie
func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/GameLevel.tscn")

# Retourne au menu principal
func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")
