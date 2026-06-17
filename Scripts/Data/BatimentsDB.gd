class_name BatimentsDB
extends Node

static func get_default_data() -> Dictionary:
	return {
		"principal": {
			"nom": "Headquarters",
			"pers": 0,
			"etat": true,
			"reparation_restante": 0,
			"tour_cout": 6,
			"pv": 75,
			"cout": 350000,
			"gain_argent": 5000
		},
		"rech": {
			"nom": "Research Lab",
			"pers": 0,
			"etat": true,
			"reparation_restante": 0,
			"tour_cout": 5,
			"pv": 70,
			"cout": 150000,
			"gain_argent": 25000
		},
		"rech2": {
			"nom": "Research Lab 2",
			"pers": 0,
			"etat": true,
			"reparation_restante": 0,
			"tour_cout": 5,
			"pv": 70,
			"cout": 150000,
			"gain_argent": 25000
		},
		"antenne": {
			"nom": "Communications",
			"pers": 0,
			"etat": true,
			"reparation_restante": 0,
			"tour_cout": 7,
			"pv": 65,
			"cout": 280000,
			"gain_argent": 10000
		},
		"infirmerie": {
			"nom": "Infirmary",
			"pers": 0,
			"etat": true,
			"reparation_restante": 0,
			"tour_cout": 3,
			"pv": 80,
			"cout": 80000,
			"gain_argent": 2000
		},
		"restauration": {
			"nom": "Cafeteria",
			"pers": 0,
			"etat": true,
			"reparation_restante": 0,
			"tour_cout": 3,
			"pv": 75,
			"cout": 90000,
			"gain_argent": 5000
		},
		"stockage": {
			"nom": "Storage",
			"pers": 0,
			"etat": true,
			"reparation_restante": 0,
			"tour_cout": 4,
			"pv": 70,
			"cout": 120000,
			"gain_argent": 15000
		},
		"temps": {
			"nom": "Observatory",
			"pers": 0,
			"etat": true,
			"reparation_restante": 0,
			"tour_cout": 5,
			"pv": 65,
			"cout": 200000,
			"gain_argent": 35000
		}
	}
