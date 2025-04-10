extends Control

@export var game_manager: Node
@export var category_options: Dictionary = {
	"Habitat": ["Bosque", "Pradera", "Monte", "Lago", "Cueva"],
	"Actividad": ["Día", "Noche"],
	"Socialidad": ["Solitario", "Grupal"]
}
var button_paths = {
	"Habitat": "Panel/VBoxContainer/Habitat/Habitat_OptionButton",
	"Actividad": "Panel/VBoxContainer/Actividad/Actividad_OptionButton",
	"Socialidad": "Panel/VBoxContainer/Socialidad/Socialidad_OptionButton"
}

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS 
	update_ui()
	hide_log()
	set_process_unhandled_input(true)

func update_ui():
	for category in category_options.keys():
		var button: OptionButton = get_node_or_null(button_paths[category])
		if button:
			button.clear()
			for option in category_options[category]:
				button.add_item(option)

func _on_option_selected(index: int, button: OptionButton, category: String):
	print(category, "selected:", button.get_item_text(index))

func toggle_log():
	if visible:
		hide_log()
	else:
		show_log()
		
func show_log():
	visible = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process_unhandled_input(true)

func hide_log():
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_process_unhandled_input(true)

func _on_cerrar_pressed():
	hide_log()
	
