class_name GameModel
extends Node

# --- DONNÉES PURES ---
var argent: int = 150000
var argent_depense: int = 0
var pers_totales: int = 50
var pers_dispo: int = 50
var tour_actuel: int = 1

var moisJour: int = 1
var moisNuit: int = 0
var is_night_mode: bool = false 

var barre_survie: float = 35 
var argent_genere_ce_tour: int = 0

var batiments_data: Dictionary = BatimentsDB.get_default_data()

# --- LOGIQUE ---

# Cette fonction retourne maintenant un int (nombre entier)
# 0 = Continue, 1 = Perdu, 2 = Gagné
# --- LOGIQUE ---
# Exécute un tour complet (réparations, PV, gains, barre de survie, fins)
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
		# Si le bâtiment est déjà détruit, on ne touche plus à ses PV
		if not b.etat:
			b.pv = 0 # On s'assure qu'il reste bien à 0 et pas -10
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
		# On oblige la valeur à rester entre 0 et 100
		# Comme ça, impossible d'avoir 120 PV ou -10 PV
		b.pv = clamp(b.pv, 0, 100)

		# --- VERIFICATION DESTRUCTION ---
		if b.pv <= 0:
			b.etat = false
			b.pv = 0 # Sécurité supplémentaire
			print(b.nom + " est détruit !")
		else:
			var gain = b.gain_argent
			if tour_actuel >= 26:
				gain = int(gain / 2)
				print("MALUS FROID : Revenus divisés pour " + b.nom)
			
			argent_genere_ce_tour += gain
			print(b.nom + " génère " + str(gain) + "€")

	argent += argent_genere_ce_tour
	print("Argent généré au total : " + str(argent_genere_ce_tour))
	print("Total argent : " + str(argent))

	# 2. Calcul barre de survie
	for key in batiments_data:
		var b = batiments_data[key]
		if b.reparation_restante > 0 or not b.etat or b.pv < 50:
			barre_survie -= 0.5
		else:
			barre_survie += 0.5
	
	barre_survie = clamp(barre_survie, 0, 100)
	
	tour_actuel += 1
	print("-----------------")
	print("FIN DU TOUR : " + str(tour_actuel))
	
	# 3. Gestion Jour/Nuit
	gerer_jour_nuit()
	
	# --- CONDITIONS DE FIN ---
	if barre_survie <= 0:
		return 1
	
	if not GameData.mode_infini and tour_actuel > 24:
		return 2
		
	return 0


# Gère l’alternance des cycles jour/nuit et déclenche les transitions
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



# Fonction pour emballer toutes les infos de fin de partie
# Construit les statistiques finales utilisées par les écrans de fin
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
