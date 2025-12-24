class_name BatimentsDB
extends Node

# Fournit les données par défaut de tous les bâtiments
static func get_default_data() -> Dictionary:
	return {
		"principal": { 
			"nom": "Batiment principal", 
			"pers": 0, 
			"etat": true, 
			"reparation_restante": 0, 
			"tour_cout": 5, 
			"pv": 70, 
			"cout": 400000,      
			"gain_argent": 5000
		},
		"rech": { 
			"nom": "Batiment recherche", 
			"pers": 0, 
			"etat": true, 
			"reparation_restante": 0, 
			"tour_cout": 5, 
			"pv": 70, 
			"cout": 150000,      
			"gain_argent": 25000
		},
		"rech2": { 
			"nom": "Batiment recherche 2", 
			"pers": 0, 
			"etat": true, 
			"reparation_restante": 0, 
			"tour_cout": 5, 
			"pv": 70, 
			"cout": 150000,      
			"gain_argent": 25000
		},
		"antenne": { 
			"nom": "Batiment antenne", 
			"pers": 0, 
			"etat": true, 
			"reparation_restante": 0, 
			"tour_cout": 5, 
			"pv": 70, 
			"cout": 300000,      
			"gain_argent": 10000
		},
		"infirmerie": { 
			"nom": "Batiment infirmerie", 
			"pers": 0, 
			"etat": true, 
			"reparation_restante": 0, 
			"tour_cout": 5, 
			"pv": 70, 
			"cout": 100000,      
			"gain_argent": 2000 
		},
		"restauration": { 
			"nom": "Batiment restaurant", 
			"pers": 0, 
			"etat": true, 
			"reparation_restante": 0, 
			"tour_cout": 5, 
			"pv": 70, 
			"cout": 100000,      
			"gain_argent": 5000
		},
		"stockage": { 
			"nom": "Batiment stockage", 
			"pers": 0, 
			"etat": true, 
			"reparation_restante": 0, 
			"tour_cout": 5, 
			"pv": 70, 
			"cout": 120000,      
			"gain_argent": 15000
		},
		"temps": { 
			"nom": "Batiment temps marketing", 
			"pers": 0, 
			"etat": true, 
			"reparation_restante": 0, 
			"tour_cout": 5, 
			"pv": 70, 
			"cout": 200000,      
			"gain_argent": 35000
		}
	}
