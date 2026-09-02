class_name GameModel
extends Node

var argent: int = 160000
var argent_depense: int = 0
var pers_totales: int = 50
var pers_dispo: int = 50
var tour_actuel: int = 1

var moisJour: int = 1
var moisNuit: int = 0
var is_night_mode: bool = false

var barre_survie: float = 50
var argent_genere_ce_tour: int = 0

var batiments_data: Dictionary = BatimentsDB.get_default_data()

# Returns: 0 = continue, 1 = game over, 2 = victory
func passer_tour() -> int:
	argent_genere_ce_tour = 0

	for key in batiments_data:
		var b = batiments_data[key]

		if b.reparation_restante > 0:
			b.reparation_restante -= 1
			if b.reparation_restante == 0:
				b.etat = true
				b.pv = 60
			continue

		if not b.etat:
			b.pv = 0
			continue

		if b.pers < 5:
			b.pv -= 8
		elif b.pers < 10:
			b.pv -= 3
		elif b.pers < 15:
			pass
		elif b.pers < 20:
			b.pv += 4
		else:
			b.pv += 8

		b.pv = clamp(b.pv, 0, 100)

		if b.pv <= 0:
			b.etat = false
			b.pv = 0
		else:
			var gain = b.gain_argent
			if tour_actuel >= 26:
				gain = int(gain * 0.6)
			argent_genere_ce_tour += gain

	argent += argent_genere_ce_tour

	# Survival bar : weighted by building health
	var total_penalty: float = 0.0
	var total_bonus: float = 0.0
	for key in batiments_data:
		var b = batiments_data[key]
		if b.reparation_restante > 0:
			total_penalty += 0.3
		elif not b.etat:
			total_penalty += 0.8
		elif b.pv < 30:
			total_penalty += 0.4
		elif b.pv < 50:
			total_penalty += 0.1
		else:
			total_bonus += 0.3

	barre_survie += total_bonus - total_penalty
	barre_survie = clamp(barre_survie, 0, 100)

	tour_actuel += 1
	gerer_jour_nuit()

	if barre_survie <= 0:
		return 1

	if not GameData.mode_infini and tour_actuel > 24:
		return 2

	return 0


func gerer_jour_nuit():
	if not is_night_mode:
		moisJour += 1
		if moisJour >= 6:
			passer_en_mode_nuit()
	else:
		moisNuit += 1
		if moisNuit >= 6:
			passer_en_mode_jour()


func passer_en_mode_nuit():
	is_night_mode = true
	moisJour = 0
	moisNuit = 0
	pers_totales = 10
	pers_dispo = 10
	reset_personnel_batiments()


func passer_en_mode_jour():
	is_night_mode = false
	moisNuit = 0
	moisJour = 0
	pers_totales = 50
	pers_dispo = 50
	reset_personnel_batiments()


func reset_personnel_batiments():
	for key in batiments_data:
		batiments_data[key].pers = 0


func recuperer_stats_finales() -> Dictionary:
	var survivants = []
	var detruits = []
	var score = 0

	for key in batiments_data:
		var b = batiments_data[key]
		if b.etat:
			survivants.append(b.nom)
			score += 1000
		else:
			detruits.append(b.nom)

	score += int(argent / 100)
	score += 5000

	return {
		"score_total": score,
		"argent_restant": argent,
		"argent_depense": argent_depense,
		"liste_survivants": survivants,
		"liste_detruits": detruits,
		"tours_tenus": tour_actuel
	}
