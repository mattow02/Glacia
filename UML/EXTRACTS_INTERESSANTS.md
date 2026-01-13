# Extraits de Code les Plus Intéressants - Projet Glacia

Ce document regroupe les algorithmes et blocs de code les plus intéressants du projet Glacia, un jeu de gestion de station polaire développé avec Godot.

---

## 🎯 1. ALGORITHME PRINCIPAL : Gestion d'un Tour de Jeu

**Fichier :** `Scripts/Models/GameModel.gd`  
**Fonction :** `passer_tour() -> int`

C'est le cœur du système de jeu. Cette fonction exécute toute la logique d'un tour : réparations, gestion des PV selon le personnel, génération d'argent, calcul de la barre de survie, et gestion des cycles jour/nuit.

```gdscript
func passer_tour() -> int:
	argent_genere_ce_tour = 0
	
	# 1. Gestion des bâtiments
	for key in batiments_data:
		var b = batiments_data[key]
		
		# --- GESTION REPARATION ---
		if b.reparation_restante > 0:
			b.reparation_restante -= 1
			if b.reparation_restante == 0:
				b.etat = true
				b.pv = 50 
				print(b.nom, " a été réparé !")
			continue

		# --- SI DETRUIT ---
		if not b.etat:
			b.pv = 0
			continue

		# --- NOUVELLE LOGIQUE PV ---
		if b.pers < 5:
			b.pv -= 10 # Critique
		elif b.pers < 10: # Donc entre 5 et 9
			b.pv -= 5  # Perte légère
		elif b.pers < 15: # Donc entre 10 et 14
			pass       # Stable (Rien ne se passe)
		elif b.pers < 20: # Donc entre 15 et 19
			b.pv += 5  # Gain léger
		else:             # 20 et plus
			b.pv += 20 # Gros gain

		# --- CORRECTION CRUCIALE ICI : CLAMP ---
		b.pv = clamp(b.pv, 0, 100)

		# --- VERIFICATION DESTRUCTION ---
		if b.pv <= 0:
			b.etat = false
			b.pv = 0
			print(b.nom + " est détruit !")
		else:
			var gain = b.gain_argent
			if tour_actuel >= 26:
				gain = int(gain / 2)
				print("MALUS FROID : Revenus divisés pour " + b.nom)
			
			argent_genere_ce_tour += gain
			print(b.nom + " génère " + str(gain) + "€")

	argent += argent_genere_ce_tour
	
	# 2. Calcul barre de survie
	for key in batiments_data:
		var b = batiments_data[key]
		if b.reparation_restante > 0 or not b.etat or b.pv < 50:
			barre_survie -= 0.5
		else:
			barre_survie += 0.5
	
	barre_survie = clamp(barre_survie, 0, 100)
	
	tour_actuel += 1
	
	# 3. Gestion Jour/Nuit
	gerer_jour_nuit()
	
	# --- CONDITIONS DE FIN ---
	if barre_survie <= 0:
		return 1  # Perdu
	
	if not GameData.mode_infini and tour_actuel > 24:
		return 2  # Gagné
		
	return 0  # Continue
```

**Points intéressants :**
- Système de PV basé sur des seuils de personnel (5 seuils différents)
- Gestion des états (réparation en cours, détruit, actif)
- Malus de froid après le tour 25
- Calcul de barre de survie basé sur l'état de tous les bâtiments
- Retour d'état pour gérer les fins de partie

---

## 🎨 2. SYSTÈME DE PRIORITÉ D'ANIMATIONS

**Fichier :** `Scripts/Controllers/GameController.gd`  
**Fonction :** `update_animations_batiments()`

Algorithme qui détermine quelle animation afficher pour chaque bâtiment selon un système de priorités (réparation > destruction > warning > normal).

```gdscript
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
```

**Fonction helper sécurisée :**

```gdscript
func set_anim_active(anim: AnimatedSprite2D, active: bool):
	if anim == null: return # Si l'animation n'existe pas dans la scène, on ne fait rien
	
	anim.visible = active
	if active:
		if not anim.is_playing():
			anim.play("default")
	else:
		anim.stop()
```

**Points intéressants :**
- Système de priorité explicite (if-elif-elif-else)
- Gestion gracieuse des animations manquantes (null-safe)
- Chaque état visuel a sa propre animation

---

## 🌓 3. SYSTÈME DE CYCLE JOUR/NUIT

**Fichier :** `Scripts/Models/GameModel.gd`  
**Fonctions :** `gerer_jour_nuit()`, `passer_en_mode_nuit()`, `passer_en_mode_jour()`

Système qui alterne entre 6 mois de jour et 6 mois de nuit, avec changement radical du personnel disponible.

```gdscript
# Gère l'alternance des cycles jour/nuit et déclenche les transitions
func gerer_jour_nuit():
	if not is_night_mode:
		moisJour += 1
		print("Cycle : MODE JOUR (" + str(moisJour) + "/6)")
		if moisJour >= 6:
			passer_en_mode_nuit()
	else:
		moisNuit += 1
		print("Cycle : MODE NUIT (" + str(moisNuit) + "/6)")
		if moisNuit >= 6:
			passer_en_mode_jour()

# Passe en mode nuit et réduit le personnel disponible
func passer_en_mode_nuit():
	is_night_mode = true
	moisJour = 0 
	moisNuit = 0 
	pers_totales = 10
	pers_dispo = 10
	reset_personnel_batiments()
	print(">>> TRANSITION : La Nuit polaire tombe... (Personnel réduit à 10)")

# Passe en mode jour et restaure le personnel disponible
func passer_en_mode_jour():
	is_night_mode = false
	moisNuit = 0 
	moisJour = 0 
	pers_totales = 50
	pers_dispo = 50
	reset_personnel_batiments()
	print(">>> TRANSITION : Le Soleil revient ! (Personnel remonte à 50)")

# Réinitialise le personnel affecté sur chaque bâtiment
func reset_personnel_batiments():
	for key in batiments_data:
		batiments_data[key].pers = 0
```

**Points intéressants :**
- Compteurs séparés pour jour et nuit
- Réinitialisation du personnel lors des transitions
- Impact stratégique majeur (50 → 10 personnes)

---

## 💰 4. SYSTÈME DE CALCUL DE SCORE

**Fichier :** `Scripts/Models/GameModel.gd`  
**Fonction :** `recuperer_stats_finales() -> Dictionary`

Algorithme qui calcule le score final en fonction des bâtiments survivants, de l'argent restant, et génère un rapport complet.

```gdscript
func recuperer_stats_finales() -> Dictionary:
	var survivants = []
	var detruits = []
	var score = 0

	# 1. Trier les bâtiments
	for key in batiments_data:
		var b = batiments_data[key]
		if b.etat:
			survivants.append(b.nom)
			score += 1000 # 1000 points par bâtiment vivant
		else:
			detruits.append(b.nom)

	# 2. Points pour l'argent
	# 1 point pour chaque 100€ restants
	score += int(argent / 100)

	# 3. Bonus victoire
	score += 5000

	return {
		"score_total": score,
		"argent_restant": argent,
		"argent_depense": argent_depense,
		"liste_survivants": survivants,
		"liste_detruits": detruits,
		"tours_tenus": tour_actuel
	}
```

**Points intéressants :**
- Séparation des bâtiments en deux listes
- Système de points multi-critères (bâtiments + argent)
- Bonus fixe pour la victoire
- Structure de données complète pour l'affichage

---

## 🎭 5. SYSTÈME DE CONFIGURATION DYNAMIQUE D'UI

**Fichier :** `Scripts/Controllers/GameController.gd`  
**Fonction :** `setup_batiment_ui()`

Pattern intéressant pour enregistrer toutes les références UI d'un bâtiment dans un dictionnaire structuré.

```gdscript
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
```

**Points intéressants :**
- Dictionnaire structuré pour regrouper toutes les références UI
- Initialisation dynamique du texte avec les données du modèle
- Pattern réutilisable pour 8 bâtiments différents

---

## 🌈 6. SYSTÈME DE TRANSITION VISUELLE JOUR/NUIT

**Fichier :** `Scripts/Controllers/GameController.gd`  
**Fonction :** `update_global_ui()`

Gère les transitions visuelles avec animations (tween) et alertes contextuelles.

```gdscript
func update_global_ui():
	# Mise à jour des textes de base
	argent_txt.text = str(game_model.argent) + "€"
	win_bar.value = game_model.barre_survie
	
	var tween = create_tween()
	
	if game_model.is_night_mode:
		# --- C'EST LA NUIT ---
		# Assombrir le fond
		if map_nuit: tween.tween_property(map_nuit, "modulate:a", 1.0, 1.5)
		
		# Seulement au tout premier mois (0)
		if game_model.moisNuit == 0:
			lancer_alerte("ATTENTION : LA NUIT POLAIRE TOMBE !", Color("#4debea"))
			
	else:
		# --- C'EST LE JOUR ---
		# Eclaircir le fond
		if map_nuit: tween.tween_property(map_nuit, "modulate:a", 0.0, 1.5)
		
		# Seulement au tout premier mois (0)
		if game_model.moisJour == 0:
			lancer_alerte("LE SOLEIL REVIENT ! HIVER SURVÉCU.", Color.GOLD)
			
		if game_model.tour_actuel == 25:
			lancer_alerte("ALERTE MÉTÉO : BLIZZARD ÉTERNEL DÉTECTÉ !", Color(1, 0, 0))
```

**Système d'alerte animé :**

```gdscript
func lancer_alerte(message: String, couleur_texte: Color = Color("#4debea")):
	if notif_nuit: notif_nuit.visible = true 
	if notif_label: notif_label.visible = true
	if notif_label == null or notif_nuit == null:
		return
	
	notif_label.text = message

	if notif_label.label_settings:
		notif_label.label_settings.font_color = couleur_texte
	else:
		notif_label.add_theme_color_override("font_color", couleur_texte)
	
	# Animation
	var tween = create_tween()
	
	# Apparition
	tween.tween_property(notif_nuit, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE)
	
	# Pause de 1 seconde
	tween.tween_interval(1.0)
	
	# Disparition
	tween.tween_property(notif_nuit, "modulate:a", 0.0, 0.5)
```

**Points intéressants :**
- Utilisation de Tween pour animations fluides
- Alertes contextuelles avec couleurs spécifiques
- Gestion gracieuse des éléments UI optionnels

---

## 🔧 7. SYSTÈME DE GESTION DYNAMIQUE DE BOUTONS

**Fichier :** `Scripts/Controllers/GameController.gd`  
**Fonctions :** `verifier_etat_commandes()`, `afficher_bouton_reparation()`

Algorithme qui crée/supprime dynamiquement des boutons de réparation selon l'état des bâtiments.

```gdscript
func afficher_bouton_reparation(key:String):
	var btn_name = "reparer_" + key
	if commande_vbox.has_node(btn_name): return
	
	var data = game_model.batiments_data[key]
	var bouton = Button.new()
	bouton.name = btn_name
	bouton.text = "Reparer " + data.nom + " - " + str(data.cout) + "€"
	bouton.connect("pressed", Callable(self, "_reparer_batiment").bind(key, bouton))
	commande_vbox.add_child(bouton)

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
```

**Points intéressants :**
- Création dynamique d'éléments UI
- Système de fallback (label "rien à faire")
- Gestion de l'ordre des éléments avec `move_child()`
- Connexion de signaux avec paramètres bindés

---

## 🎯 8. SYSTÈME DE COULEURS DE BARRE DE PROGRESSION

**Fichier :** `Scripts/Controllers/GameController.gd`  
**Dans :** `_on_passer_pressed()`

Système simple mais efficace de changement de couleur selon l'état des PV.

```gdscript
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
```

**Points intéressants :**
- Feedback visuel immédiat sur l'état
- Seuils clairs (50% = vert, 30% = jaune, <30% = rouge)
- Utilisation de `modulate` pour changer la couleur

---

## 📊 9. SYSTÈME DE CALCUL DE DÉLAIS DE RÉPARATION

**Fichier :** `Scripts/Controllers/GameController.gd`  
**Fonction :** `afficher_delais_reparations()`

Reconstruit dynamiquement une liste des réparations en cours avec leurs délais.

```gdscript
func afficher_delais_reparations():
	# Nettoie les anciens labels (sauf les fixes)
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
```

**Points intéressants :**
- Reconstruction complète de la liste à chaque appel
- Conservation de l'ordre avec index d'insertion
- Filtrage des éléments à conserver

---

## 🎮 10. SYSTÈME DE RÉPARATION AVEC CONTRÔLE DE PRÉREQUIS

**Fichier :** `Scripts/Controllers/GameController.gd`  
**Fonction :** `_reparer_batiment()`

Logique de réparation qui vérifie les prérequis (antenne fonctionnelle) avant d'autoriser la réparation.

```gdscript
func _reparer_batiment(key:String, bouton:Button):
	# Contrainte : L'antenne doit être fonctionnelle pour réparer les autres bâtiments
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
```

**Points intéressants :**
- Système de dépendances (antenne nécessaire)
- Vérification des ressources (argent)
- Mise à jour immédiate de l'UI après action
- Gestion asynchrone avec `await`

---

## 📝 Résumé

Ces extraits démontrent :

1. **Architecture MVC** bien structurée
2. **Systèmes de jeu complexes** avec plusieurs mécaniques interconnectées
3. **Gestion dynamique d'UI** avec création/suppression d'éléments
4. **Algorithmes de calcul** pour PV, score, barre de survie
5. **Systèmes d'état** avec transitions et priorités
6. **Patterns réutilisables** pour gérer plusieurs entités similaires
7. **Gestion gracieuse des erreurs** (null-safe, vérifications)

Le code montre une bonne séparation des responsabilités et une logique métier bien pensée pour un jeu de gestion avec cycles, ressources, et mécaniques stratégiques.
