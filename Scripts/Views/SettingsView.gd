extends PanelContainer

#@onready var volume_slider = $VolumeSlider
#@onready var volume_label = $VolumeLabel


@export var volume_slider : NodePath
@export var volume_label : NodePath


# Initialise l'overlay de volume et connecte le slider
func _ready():
	visible = false  # Cache l’overlay au démarrage

	if AudioMenu:  # Ton autoload musique
		var value = clamp((AudioMenu.volume_db + 80) / 80 * 100, 0, 100)
		get_node(volume_slider).value = value
		get_node(volume_label).text = str(round(value)) + "%"
	
	# Connecte les signaux
	get_node(volume_slider).connect("value_changed", Callable(self, "_on_volume_changed"))


# Met à jour le volume global et le pourcentage affiché
func _on_volume_changed(value):
	var db_value = lerp(-80, 0, value / 100.0)
	AudioMenu.volume_db = db_value
	get_node(volume_label).text = str(round(value)) + "%"


# Ferme l'overlay des réglages
func _on_close_pressed():
	visible = false
