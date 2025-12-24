extends Node2D

# 1. RÉFÉRENCES UI
@onready var all: Button = $all
@onready var win_bar: ProgressBar = $WinBar
@onready var argent_txt: Label = $Argent
@onready var mois: Label = $Mois
@onready var map_nuit: Sprite2D = $MapNuit
@onready var notif_nuit: ColorRect = $NotifNuit
@onready var notif_label: Label = $NotifNuit/Label

# --- ANIMATIONS REPARATION (Luigi) ---
@onready var luigi_reparation_principal: AnimatedSprite2D = $Luigi_reparation_principal
@onready var luigi_reparation_rech: AnimatedSprite2D = $Luigi_reparation_rech
@onready var luigi_reparation_rech_2: AnimatedSprite2D = $Luigi_reparation_rech2
@onready var luigi_reparation_antenne: AnimatedSprite2D = $Luigi_reparation_antenne
@onready var luigi_reparation_infirmerie: AnimatedSprite2D = $Luigi_reparation_infirmerie
@onready var luigi_reparation_restauration: AnimatedSprite2D = $Luigi_reparation_restauration
@onready var luigi_reparation_stockage: AnimatedSprite2D = $Luigi_reparation_stockage
@onready var luigi_reparation_temps: AnimatedSprite2D = $Luigi_reparation_temps

# --- ANIMATIONS DESTRUCTION ---
@onready var detruis_principal: AnimatedSprite2D = $detruis_principal
@onready var detruis_rech: AnimatedSprite2D = $detruis_rech
@onready var detruis_rech_2: AnimatedSprite2D = $detruis_rech2
@onready var detruis_antenne: AnimatedSprite2D = $detruis_antenne
@onready var detruis_infirmerie: AnimatedSprite2D = $detruis_infirmerie
@onready var detruis_restauration: AnimatedSprite2D = $detruis_restauration
@onready var detruis_stockage: AnimatedSprite2D = $detruis_stockage
@onready var detruis_temps: AnimatedSprite2D = $detruis_temps

# --- ANIMATIONS WARNING (Nouveau) ---
# IMPORTANT : Assure-toi que ces noeuds existent bien dans ta scène Godot !
@onready var warning_principal: AnimatedSprite2D = $warning_principal
@onready var warning_rech: AnimatedSprite2D = $warning_rech
@onready var warning_rech_2: AnimatedSprite2D = $warning_rech_2
@onready var warning_antenne: AnimatedSprite2D = $warning_antenne
@onready var warning_infirmerie: AnimatedSprite2D = $warning_infirmerie
@onready var warning_restauration: AnimatedSprite2D = $warning_restauration
@onready var warning_stockage: AnimatedSprite2D = $warning_stockage
@onready var warning_temps: AnimatedSprite2D = $warning_temps

# Fenêtres des bâtiments
@onready var bat_principal_windows: PanelContainer = $bat_PrincipalWindows
@onready var bat_rech_windows: PanelContainer = $bat_rechWindows
@onready var bat_rech2_windows: PanelContainer = $bat_rech2Windows
@onready var bat_antenne_windows: PanelContainer = $bat_antenneWindows
@onready var bat_infirmerie_windows: PanelContainer = $bat_infirmerieWindows
@onready var bat_restauration_windows: PanelContainer = $bat_restaurationWindows
@onready var bat_stockage_windows: PanelContainer = $bat_stockageWindows
@onready var bat_temps_windows: PanelContainer = $bat_tempsWindows

# Fenêtres spéciales
@onready var commande_windows: PanelContainer = $CommandeWindows
@onready var commande_vbox: VBoxContainer = $CommandeWindows/VBoxContainer
@onready var bat_detruit_windows: PanelContainer = $bat_detruitWindows
@onready var nom_detruit: Label = $bat_detruitWindows/VBoxContainer/nom_detruit
@onready var delais_commande_windows: PanelContainer = $delais_commandeWindows
@onready var delais_vbox: VBoxContainer = $delais_commandeWindows/VBoxContainer
@onready var menu_pause: PanelContainer = $Menu_pause

# Boutons Bâtiments
@onready var bat_principal_btn: Button = $bat_Principal
@onready var bat_rech_btn: Button = $bat_rech_pousse
@onready var bat_rech2_btn: Button = $bat_rech_pousse2
@onready var bat_antenne_btn: Button = $Antenne_market
@onready var bat_infirmerie_btn: Button = $bat_infirmerie
@onready var bat_restauration_btn: Button = $bat_restauration
@onready var bat_stockage_btn: Button = $bat_stockage
@onready var bat_temps_btn: Button = $bat_temps_market

# 2. INSTANCE DU MODÈLE
var game_model: GameModel
var current_bat_ui_key := ""
var batiments_ui = {}

# Prépare les références, l'UI et l'état initial du jeu
func _ready() -> void:
	game_model = GameModel.new()
	add_child(game_model)
	
	if map_nuit:
		map_nuit.modulate.a = 0.0
	if notif_nuit: notif_nuit.modulate.a = 0.0

	
	win_bar.min_value = 0
	win_bar.max_value = 100
	
	# SETUP UI : On passe les TROIS animations
	# Note : Si un warning n'est pas créé dans la scène, la variable sera 'null', mais le code gérera ça.
	setup_batiment_ui("principal", $bat_Principal, $bat_PrincipalWindows, $bat_PrincipalWindows/VBoxContainer/etat_bat_Principal, $bat_PrincipalWindows/VBoxContainer/Personnes, $bat_PrincipalWindows/VBoxContainer/DonneesCommunes, $bat_PrincipalWindows/VBoxContainer/Nom, $Luigi_reparation_principal, $detruis_principal, $warning_principal)
	setup_batiment_ui("rech", $bat_rech_pousse, $bat_rechWindows, $bat_rechWindows/VBoxContainer/etat_bat_Rech, $bat_rechWindows/VBoxContainer/Personnes, $bat_rechWindows/VBoxContainer/DonneesCommunes, $bat_rechWindows/VBoxContainer/Nom, $Luigi_reparation_rech, $detruis_rech, $warning_rech)
	setup_batiment_ui("rech2", $bat_rech_pousse2, $bat_rech2Windows, $bat_rech2Windows/VBoxContainer/etat_bat_Rech2, $bat_rech2Windows/VBoxContainer/Personnes, $bat_rech2Windows/VBoxContainer/DonneesCommunes, $bat_rech2Windows/VBoxContainer/Nom, $Luigi_reparation_rech2, $detruis_rech2, $warning_rech_2)
	setup_batiment_ui("antenne", $Antenne_market, $bat_antenneWindows, $bat_antenneWindows/VBoxContainer/etat_bat_Antenne, $bat_antenneWindows/VBoxContainer/Personnes, $bat_antenneWindows/VBoxContainer/DonneesCommunes, $bat_antenneWindows/VBoxContainer/Nom, $Luigi_reparation_antenne, $detruis_antenne, $warning_antenne)
	setup_batiment_ui("infirmerie", $bat_infirmerie, $bat_infirmerieWindows, $bat_infirmerieWindows/VBoxContainer/etat_bat_Infirmerie, $bat_infirmerieWindows/VBoxContainer/Personnes, $bat_infirmerieWindows/VBoxContainer/DonneesCommunes, $bat_infirmerieWindows/VBoxContainer/Nom, $Luigi_reparation_infirmerie, $detruis_infirmerie, $warning_infirmerie)
	setup_batiment_ui("restauration", $bat_restauration, $bat_restaurationWindows, $bat_restaurationWindows/VBoxContainer/etat_bat_Restauration, $bat_restaurationWindows/VBoxContainer/Personnes, $bat_restaurationWindows/VBoxContainer/DonneesCommunes, $bat_restaurationWindows/VBoxContainer/Nom, $Luigi_reparation_restauration, $detruis_restauration, $warning_restauration)
	setup_batiment_ui("stockage", $bat_stockage, $bat_stockageWindows, $bat_stockageWindows/VBoxContainer/etat_bat_Stockage, $bat_stockageWindows/VBoxContainer/Personnes, $bat_stockageWindows/VBoxContainer/DonneesCommunes, $bat_stockageWindows/VBoxContainer/Nom, $Luigi_reparation_stockage, $detruis_stockage, $warning_stockage)
	setup_batiment_ui("temps", $bat_temps_market, $bat_tempsWindows, $bat_tempsWindows/VBoxContainer/etat_bat_Temps, $bat_tempsWindows/VBoxContainer/Personnes, $bat_tempsWindows/VBoxContainer/DonneesCommunes, $bat_tempsWindows/VBoxContainer/Nom, $Luigi_reparation_temps, $detruis_temps, $warning_temps)

	# Masquer les fenêtres, boutons et TOUTES les animations
	for key in batiments_ui:
		batiments_ui[key].panel.visible = false
		batiments_ui[key].button.modulate = Color(1, 1, 1, 0)
		batiments_ui[key].bar.modulate = Color.GREEN
		
		# On utilise une fonction sécurisée pour éviter le crash si l'animation est 'null'
		set_anim_active(batiments_ui[key].anim_repar, false)
		set_anim_active(batiments_ui[key].anim_detruit, false)
		set_anim_active(batiments_ui[key].anim_warning, false)

	all.visible = false
	commande_windows.visible = false
	bat_detruit_windows.visible = false
	delais_commande_windows.visible = false
	menu_pause.visible = false

	update_global_ui()
	_update_all_labels()
	
	print("--- DÉBUT DU JEU ---")
	print("Mode Jour : moisJour = " + str(game_model.moisJour))

# Enregistre les éléments UI/animations d'un bâtiment et initialise ses libellés
func setup_batiment_ui(key: String, button, panel, bar, label_pers, label_comm, label_nom, anim_repar, anim_detruit, anim_warning):
	batiments_ui[key] = {
		"button": button,
		"panel": panel,
		"bar": bar,
		"label_pers": label_pers,
		"label_common": label_comm,
		"label_nom": label_nom,
		"anim_repar": anim_repar,    # Animation Luigi
		"anim_detruit": anim_detruit, # Animation Destruction
		"anim_warning": anim_warning  # Animation Warning
	}
	
	var data = game_model.batiments_data[key]
	var texte_titre = data.nom
	texte_titre += "\nGain mensuel : " + str(data.gain_argent) + "€"
	texte_titre += " - Cout reparation : " + str(data.cout) + "€"
	texte_titre += "\nEtat du batiment :"
	
	label_nom.text = texte_titre
	bar.value = data.pv

# --- GESTION DES ANIMATIONS (LOGIQUE PRINCIPALE) ---
# Choisit quelle animation afficher selon l'état de chaque bâtiment
func update_animations_batiments():
	for key in batiments_ui:
		var data = game_model.batiments_data[key]
		var anim_repar = batiments_ui[key].anim_repar
		var anim_detruit = batiments_ui[key].anim_detruit
		var anim_warning = batiments_ui[key].anim_warning
		
		# CAS 1 : EN REPARATION (Priorité absolue)
		if data.reparation_restante > 0:
			set_anim_active(anim_repar, true)
			set_anim_active(anim_detruit, false)
			set_anim_active(anim_warning, false)
			
		# CAS 2 : DETRUIT (Et PAS en réparation)
		elif not data.etat: 
			set_anim_active(anim_repar, false)
			set_anim_active(anim_detruit, true)
			set_anim_active(anim_warning, false)
			
		# CAS 3 : WARNING (Entre 0% et 20%)
		elif data.pv <= 20:
			set_anim_active(anim_repar, false)
			set_anim_active(anim_detruit, false)
			set_anim_active(anim_warning, true)
			
		# CAS 4 : NORMAL (Tout va bien)
		else:
			set_anim_active(anim_repar, false)
			set_anim_active(anim_detruit, false)
			set_anim_active(anim_warning, false)

# FONCTION HELPER (Sécurisée contre les crashs si l'animation manque)
# Active ou désactive une animation en évitant les accès null
func set_anim_active(anim: AnimatedSprite2D, active: bool):
	if anim == null: return # Si l'animation n'existe pas dans la scène, on ne fait rien
	
	anim.visible = active
	if active:
		if not anim.is_playing():
			anim.play("default")
	else:
		anim.stop()


func update_global_ui():
	# Mise à jour des textes de base
	argent_txt.text = str(game_model.argent) + "€"
	win_bar.value = game_model.barre_survie
	
	var tween = create_tween()
	
	if game_model.is_night_mode:
		# --- C'EST LA NUIT ---
		# Assombrir le fond
		if map_nuit: tween.tween_property(map_nuit, "modulate:a", 1.0, 1.5)
		
		# [CORRECTION] On remet la condition : Seulement au tout premier mois (0)
		if game_model.moisNuit == 0:
			lancer_alerte("ATTENTION : LA NUIT POLAIRE TOMBE !", Color("#4debea"))
			
	else:
		# --- C'EST LE JOUR ---
		# Eclaircir le fond
		if map_nuit: tween.tween_property(map_nuit, "modulate:a", 0.0, 1.5)
		
		# [NOUVEAU] On remet la condition : Seulement au tout premier mois (0)
		if game_model.moisJour == 0:
			lancer_alerte("LE SOLEIL REVIENT ! HIVER SURVÉCU.", Color.GOLD)
			
		if game_model.tour_actuel == 25:
			lancer_alerte("ALERTE MÉTÉO : BLIZZARD ÉTERNEL DÉTECTÉ !", Color(1, 0, 0))


func lancer_alerte(message: String, couleur_texte: Color = Color("#4debea")):
	if notif_nuit: notif_nuit.visible = true 
	if notif_label: notif_label.visible = true
	if notif_label == null or notif_nuit == null:
		return
	# 1. On met le texte qu'on a reçu en paramètre
	notif_label.text = message

	# 2. On change la couleur du texte (Cyan pour nuit, Or pour jour...)
	if notif_label.label_settings:
		notif_label.label_settings.font_color = couleur_texte
	else:
		# Si vous n'utilisez pas LabelSettings mais les Theme Overrides :
		notif_label.add_theme_color_override("font_color", couleur_texte)
	
	# 3. L'animation (Identique à avant)
	var tween = create_tween()
	
	# Apparition
	tween.tween_property(notif_nuit, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE)
	
	# Pause de 3 secondes
	tween.tween_interval(1.0)
	
	# Disparition
	tween.tween_property(notif_nuit, "modulate:a", 0.0, 0.5)

	
func _update_all_labels() -> void:
	for key in batiments_ui:
		var ui = batiments_ui[key]
		var data = game_model.batiments_data[key]
		
		ui.label_common.text = "Personnes disponibles : " + str(game_model.pers_dispo) + "/" + str(game_model.pers_totales)
		ui.label_pers.text = "Personnes : " + str(data.pers)
		ui.bar.value = data.pv

# --- LOGIQUE PASSER TOUR ---
# Avance d'un tour, met à jour UI/animations et gère les fins de partie
func _on_passer_pressed() -> void:
	var game_status = game_model.passer_tour()
	mois.text = "Mois : " + str(game_model.tour_actuel)
	
	# Mise à jour des animations
	update_animations_batiments()
	
	# Affichage conditionnel des boutons de réparation
	for key in game_model.batiments_data:
		var data = game_model.batiments_data[key]
		
		# On affiche le bouton réparer SI :
		# 1. Le bâtiment est cassé (etat == false)
		# 2. PV à 0
		# 3. PAS de réparation en cours (reparation_restante == 0)
		if not data.etat and data.pv <= 0 and data.reparation_restante == 0:
			afficher_bouton_reparation(key)

	# Couleurs des barres
	for key in batiments_ui.keys():
		var ui_elements = batiments_ui[key]
		var bar = ui_elements.bar
		var data = game_model.batiments_data[key]
		
		if data.pv >= 50:
			bar.modulate = Color.GREEN
		elif data.pv >= 30 and data.pv < 50:
			bar.modulate = Color.YELLOW
		elif data.pv < 30:
			bar.modulate = Color.RED

	update_global_ui()
	_update_all_labels()
	
	if delais_commande_windows.visible:
		afficher_delais_reparations()

	if game_status == 1:
		_change_to_game_over()
	elif game_status == 2:
		_change_to_game_win()

# --- GESTION FENÊTRES ---
# Ouvre la fenêtre d'un bâtiment s'il est intact, sinon affiche la fenêtre détruite
func open_batiment(key: String) -> void:
	var data = game_model.batiments_data[key]
	if data.etat:
		current_bat_ui_key = key
		for k in batiments_ui:
			batiments_ui[k].panel.visible = (k == key)
		all.visible = true
	else:
		open_destruct_batiment(data.nom)

# Affiche la fenêtre indiquant qu'un bâtiment est détruit
func open_destruct_batiment(bat_name: String) -> void:
	nom_detruit.text = "Batiment " + bat_name
	bat_detruit_windows.visible = true
	all.visible = true

# Ferme toutes les fenêtres de bâtiments
func _on_fermer_pressed() -> void:
	all.visible = false
	for k in batiments_ui:
		batiments_ui[k].panel.visible = false
	current_bat_ui_key = ""

# --- GESTION PERSONNEL ---
# Ajoute 1 personne au bâtiment courant si disponible
func _on_ajouter_pressed() -> void:
	if current_bat_ui_key != "" and game_model.pers_dispo > 0:
		game_model.pers_dispo -= 1
		game_model.batiments_data[current_bat_ui_key].pers += 1
		_update_all_labels()

# Retire 1 personne du bâtiment courant
func _on_retirer_pressed() -> void:
	if current_bat_ui_key != "":
		var data = game_model.batiments_data[current_bat_ui_key]
		if data.pers > 0:
			game_model.pers_dispo += 1
			data.pers -= 1
			_update_all_labels()

# Ajoute jusqu'à 10 personnes au bâtiment courant
func _on_pdix_personnes_pressed() -> void:
	if current_bat_ui_key != "" and game_model.pers_dispo > 0:
		var ajout = min(10, game_model.pers_dispo)
		game_model.pers_dispo -= ajout
		game_model.batiments_data[current_bat_ui_key].pers += ajout
		_update_all_labels()

# Retire jusqu'à 10 personnes du bâtiment courant
func _on_mdix_personnes_pressed() -> void:
	if current_bat_ui_key != "":
		var data = game_model.batiments_data[current_bat_ui_key]
		var retrait = min(10, data.pers)
		data.pers -= retrait
		game_model.pers_dispo += retrait
		_update_all_labels()


# --- REPARATIONS ET COMMANDES ---
# Crée dynamiquement un bouton de réparation pour un bâtiment détruit
func afficher_bouton_reparation(key:String):
	var btn_name = "reparer_" + key
	if commande_vbox.has_node(btn_name): return
	
	var data = game_model.batiments_data[key]
	var bouton = Button.new()
	bouton.name = btn_name
	bouton.text = "Reparer " + data.nom + " - " + str(data.cout) + "€"
	bouton.connect("pressed", Callable(self, "_reparer_batiment").bind(key, bouton))
	commande_vbox.add_child(bouton)

# Débite l'argent, planifie la réparation et met à jour l'UI/animations
func _reparer_batiment(key:String, bouton:Button):
	if key != "antenne":
		if game_model.batiments_data["antenne"].etat == false:
			print("IMPOSSIBLE : L'antenne est détruite !")
			return
	
	var data = game_model.batiments_data[key]
	if game_model.argent >= data.cout:
		game_model.argent -= data.cout
		game_model.argent_depense += data.cout # Stats de fin
		
		data.reparation_restante = data.tour_cout
		update_global_ui()
		
		# On met à jour les animations (Luigi va remplacer la destruction)
		update_animations_batiments()
		
		bouton.queue_free()
		await get_tree().process_frame
		verifier_etat_commandes()
	else:
		print("Pas assez d'argent")

# Ouvre la fenêtre des commandes de réparation
func _on_commander_pressed() -> void:
	commande_windows.visible = true
	verifier_etat_commandes()

# Ferme la fenêtre des commandes de réparation
func _on_fermer_commande_pressed() -> void:
	commande_windows.visible = false
	
# Affiche le détail des délais de réparations
func _on_delais_commande_pressed() -> void:
	afficher_delais_reparations()
	delais_commande_windows.visible = true

# Ferme la fenêtre des délais de réparations
func _on_fermer_delais_commande_pressed() -> void:
	delais_commande_windows.visible = false

# Met à jour le contenu de la fenêtre commandes (boutons ou message vide)
func verifier_etat_commandes():
	var nb_boutons_reparation = 0
	for child in commande_vbox.get_children():
		if child is Button and child.name != "fermer_commande":
			nb_boutons_reparation += 1

	var nom_label = "LabelRienAFaire"
	var label_existe = commande_vbox.has_node(nom_label)

	if nb_boutons_reparation == 0:
		if not label_existe:
			var label = Label.new()
			label.name = nom_label
			label.text = "Aucune reparation a faire pour le moment."
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.add_theme_color_override("font_color", Color.BLACK)
			label.add_theme_font_size_override("font_size", 30)
			commande_vbox.add_child(label)
			if commande_vbox.has_node("fermer_commande"):
				var btn_fermer = commande_vbox.get_node("fermer_commande")
				commande_vbox.move_child(label, btn_fermer.get_index())
	else:
		if label_existe:
			commande_vbox.get_node(nom_label).queue_free()

# Reconstruit la liste des réparations en cours et leur délai
func afficher_delais_reparations():
	for c in delais_vbox.get_children():
		if c.name != "Temps_attente" and c.name != "fermer_delais_commande":
			c.queue_free()

	var index_insertion = 1
	for key in game_model.batiments_data:
		var data = game_model.batiments_data[key]
		if data.reparation_restante > 0:
			var label = Label.new()
			label.text = "- " + data.nom + " : " + str(data.reparation_restante) + " mois restants"
			label.add_theme_color_override("font_color", Color(1, 0.2, 0.2))
			label.add_theme_font_size_override("font_size", 24)
			delais_vbox.add_child(label)
			delais_vbox.move_child(label, index_insertion)
			index_insertion += 1

# Ferme la fenêtre indiquant un bâtiment détruit
func _on_fermer_detruit_pressed() -> void:
	bat_detruit_windows.visible = false
	all.visible = false

# --- NAVIGATION ---
# Ouvre le menu pause
func _on_revenir_pressed() -> void:
	menu_pause.visible = true
	$Quitter.visible = true
	$Reprendre.visible = true
# Ferme le menu pause
func _on_reprendre_pressed() -> void:
	menu_pause.visible = false
	$Quitter.visible = false
	$Reprendre.visible = false

# Retourne au menu principal
func _on_quitter_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")

# Passe à la scène Game Over en stockant les stats
func _change_to_game_over() -> void:
	var stats = game_model.recuperer_stats_finales()
	GameData.stats_fin_de_partie = stats
	get_tree().change_scene_to_file("res://Scenes/UI/GameOver.tscn")

# Passe à la scène de victoire en stockant les stats
func _change_to_game_win() -> void:
	var stats = game_model.recuperer_stats_finales()
	GameData.stats_fin_de_partie = stats
	get_tree().change_scene_to_file("res://Scenes/UI/GameWin.tscn")

# --- SIGNAUX OUVERTURE BATIMENTS ---
# Ouvre la fenêtre du bâtiment principal
func _on_bat_principal_pressed() -> void: open_batiment("principal")
# Ouvre la fenêtre du bâtiment recherche 1
func _on_bat_rech_pousse_pressed() -> void: open_batiment("rech")
# Ouvre la fenêtre du bâtiment recherche 2
func _on_bat_rech_pousse_2_pressed() -> void: open_batiment("rech2")
# Ouvre la fenêtre du bâtiment antenne
func _on_antenne_market_pressed() -> void: open_batiment("antenne")
# Ouvre la fenêtre du bâtiment infirmerie
func _on_bat_infirmerie_pressed() -> void: open_batiment("infirmerie")
# Ouvre la fenêtre du bâtiment restauration
func _on_bat_restauration_pressed() -> void: open_batiment("restauration")
# Ouvre la fenêtre du bâtiment stockage
func _on_bat_stockage_pressed() -> void: open_batiment("stockage")
# Ouvre la fenêtre du bâtiment temps marketing
func _on_bat_temps_market_pressed() -> void: open_batiment("temps")
