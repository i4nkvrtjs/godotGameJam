extends Control

@export var game_manager: Node
@export var animals := [
	{
		"Nombre": "Panthera Onca",
		"Habitat": "Bosque",
		"Actividad": "Diurno",
		"Socialidad": "Solitario",
		"Interactuable": ["Habitat", "Socialidad"],
		"Locked": false
	},
	{
		"Nombre": "Hippocamelus Bisulcus",
		"Habitat": "Bosque",
		"Actividad": "Diurno",
		"Socialidad": "Solitario",
		"Interactuable": ["Socialidad"],
		"Locked": false
	},
	{
		"Nombre": "Tyto Alba",
		"Habitat": "Bosque",
		"Actividad": "Nocturno",
		"Socialidad": "Solitario",
		"Interactuable": ["Actividad", "Socialidad"],
		"Locked": false
	},
	{
		"Nombre": "Chonchón",
		"Habitat": "Cueva",
		"Actividad": "Nocturno",
		"Socialidad": "Grupal",
		"Interactuable": ["Habitat", "Actividad", "Socialidad"],
		"Locked": false
	},
	{
		"Nombre": "Caimán Yacaré",
		"Habitat": "Lago",
		"Actividad": "Diurno",
		"Socialidad": "Grupal",
		"Interactuable": ["Habitat", "Actividad"],
		"Locked": false
	},
	{
		"Nombre": "Nahuelito",
		"Habitat": "Lago",
		"Actividad": "Nocturno",
		"Socialidad": "Solitario",
		"Interactuable": ["Habitat", "Actividad","Socialidad"],
		"Locked": false
	},
	{
		"Nombre": "Nyctibius Griseus",
		"Habitat": "Monte",
		"Actividad": "Diurno",
		"Socialidad": "Solitario",
		"Interactuable": ["Socialidad"],
		"Locked": false
	},
	{
		"Nombre": "Priodontes Maximus",
		"Habitat": "Monte",
		"Actividad": "Diurno",
		"Socialidad": "Solitario",
		"Interactuable": ["Habitat"],
		"Locked": false
	},
	{
		"Nombre": "Chancha con Cadenas",
		"Habitat": "Monte",
		"Actividad": "Nocturno",
		"Socialidad": "Solitario",
		"Interactuable": ["Actividad", "Socialidad"],
		"Locked": false
	},
	{
		"Nombre": "Hydrochoerus Hydrochaeris",
		"Habitat": "Pradera",
		"Actividad": "Diurno",
		"Socialidad": "Grupal",
		"Interactuable": ["Actividad"],
		"Locked": false
	},
	{
		"Nombre": "Aguará Guazú",
		"Habitat": "Pradera",
		"Actividad": "Nocturno",
		"Socialidad": "Solitario",
		"Interactuable": ["Actividad", "Socialidad"],
		"Locked": false
	}
]

@export var category_options: Dictionary = {
	"Habitat": ["Bosque", "Pradera", "Monte", "Lago", "Cueva"],
	"Actividad": ["Diurno", "Nocturno"],
	"Socialidad": ["Solitario", "Grupal"]
}
var categoryElements = {
	"Habitat": {
		"left_button": "Panel/VBoxContainer/CategoryOptions/Habitat/LeftButton",
		"right_button": "Panel/VBoxContainer/CategoryOptions/Habitat/RightButton",
		"label": "Panel/VBoxContainer/CategoryOptions/Habitat/HabitatLabel"
	},
	"Actividad": {
		"left_button": "Panel/VBoxContainer/CategoryOptions/Actividad/LeftButton",
		"right_button": "Panel/VBoxContainer/CategoryOptions/Actividad/RightButton",
		"label": "Panel/VBoxContainer/CategoryOptions/Actividad/ActividadLabel"
	},
	"Socialidad": {
		"left_button": "Panel/VBoxContainer/CategoryOptions/Socialidad/LeftButton",
		"right_button": "Panel/VBoxContainer/CategoryOptions/Socialidad/RightButton",
		"label": "Panel/VBoxContainer/CategoryOptions/Socialidad/SocialidadLabel"
	}
}

var currentAnimalIndex : int = 0
var isLogOpen : bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS 
	update_ui()
	hide_log()

func update_ui():
	var animal = animals[currentAnimalIndex]
	$Panel/VBoxContainer/AnimalName.text = animal["Nombre"]

	var check_button: Button = $Panel/VBoxContainer/CheckButton


	if "Selected" not in animal:
		animal["Selected"] = {}

	if animal.get("Locked", false):
		check_button.text = "Información completa"
		check_button.disabled = true  
		check_button.add_theme_color_override("font_color", Color(0, 0.6, 1)) 
	else:
		check_button.text = "Check Information"
		check_button.disabled = false  
		check_button.remove_theme_color_override("font_color")  

	
	for category in category_options.keys():
		var left_button: Button = get_node_or_null(categoryElements[category]["left_button"])
		var right_button: Button = get_node_or_null(categoryElements[category]["right_button"])
		var label: Label = get_node_or_null(categoryElements[category]["label"])

		if left_button and right_button and label:
			var esInteractuable = category in animal["Interactuable"]
			var isLocked = animal.get("Locked", false)

			if not esInteractuable or isLocked:
				label.text = animal[category]
				left_button.visible = false
				right_button.visible = false
			else:
				
				if category not in animal["Selected"]:
					animal["Selected"][category] = category_options[category][0]

				label.text = animal["Selected"][category]
				left_button.visible = true
				right_button.visible = true

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

func next_animal():
	if currentAnimalIndex < animals.size() -1:	
		currentAnimalIndex += 1
		update_ui()

func change_option(category: String, direction: int):
	var animal = animals[currentAnimalIndex]
	if category in animal["Interactuable"] and not animal["Locked"]:
		var label: Label = get_node_or_null(categoryElements[category]["label"])
		if label:
			var options = category_options[category]

			
			if category not in animal["Selected"]:
				animal["Selected"][category] = options[0]

			var current_index = options.find(animal["Selected"][category])
			var new_index = (current_index + direction) % options.size()

			label.text = options[new_index]
			animal["Selected"][category] = options[new_index]  



func _on_habitat_left_pressed():
	change_option("Habitat", -1)

func _on_habitat_right_pressed():
	change_option("Habitat", 1)

func _on_actividad_left_pressed():
	change_option("Actividad", -1)

func _on_actividad_right_pressed():
	change_option("Actividad", 1)

func _on_socialidad_left_pressed():
	change_option("Socialidad", -1)

func _on_socialidad_right_pressed():
	change_option("Socialidad", 1)

func prev_animal():
	if currentAnimalIndex > 0:
		currentAnimalIndex -= 1
		update_ui()
		
func _input(event):
	if event.is_action_pressed("toggleLog"):
		toggle_log()
	elif event.is_action_pressed("logNext"):
		next_animal()
	elif event.is_action_pressed("logPrev"):
		prev_animal()

func check_information():
	var animal = animals[currentAnimalIndex]
	var all_correct = true

	for category in category_options.keys():
		if category in animal["Interactuable"]:
			if animal["Selected"].get(category) != animal[category]:
				all_correct = false

	var check_button: Button = $Panel/VBoxContainer/CheckButton
	var option_buttons = $Panel/VBoxContainer/CategoryOptions.get_children()  

	if all_correct:
		animal["Locked"] = true
		check_button.text = "¡Correcto!"
		check_button.add_theme_color_override("font_color", Color(0, 1, 0)) 
		
		for button in option_buttons:
			if button is VBoxContainer:
				button.visible = false
	else:
		check_button.text = "¡Incorrecto!"
		check_button.add_theme_color_override("font_color", Color(1, 0, 0)) 
	
	check_button.disabled = true
	await get_tree().create_timer(2.0).timeout

	if all_correct:
		check_button.text = "Información completa"
		check_button.disabled = true 
	else:
		check_button.text = "Check Information"
		check_button.remove_theme_color_override("font_color") 
		check_button.disabled = false 

func _on_check_button_pressed():
	check_information()
