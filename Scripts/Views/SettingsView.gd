extends PanelContainer

@export var volume_slider : NodePath
@export var volume_label : NodePath


func _ready():
	visible = false

	# Ice theme
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.04, 0.07, 0.14, 0.92)
	style.border_color = Color(0.25, 0.5, 0.75, 0.3)
	style.set_border_width_all(1)
	style.set_corner_radius_all(10)
	style.shadow_color = Color(0.08, 0.15, 0.3, 0.2)
	style.shadow_size = 5
	style.set_content_margin_all(14)
	add_theme_stylebox_override("panel", style)

	# Close button
	var close_btn = Button.new()
	close_btn.text = "Close"
	close_btn.flat = true
	close_btn.add_theme_color_override("font_color", Color(0.85, 0.92, 0.98))
	close_btn.pressed.connect(_on_close_pressed)
	$VBoxContainer.add_child(close_btn)

	if AudioMenu:
		var value = clamp((AudioMenu.volume_db + 80) / 80 * 100, 0, 100)
		get_node(volume_slider).value = value
		get_node(volume_label).text = str(round(value)) + "%"

	get_node(volume_slider).connect("value_changed", Callable(self, "_on_volume_changed"))


func _on_volume_changed(value):
	var db_value = lerp(-80, 0, value / 100.0)
	AudioMenu.volume_db = db_value
	get_node(volume_label).text = str(round(value)) + "%"


func _on_close_pressed():
	visible = false
