extends Button

# Cache le conteneur parent de l'overlay quand on clique
func _on_pressed():
	get_parent().get_parent().visible = false
