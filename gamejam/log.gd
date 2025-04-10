extends Control

@export var game_manager: Node
@export var animals := [
	{
		"Nombre": "Panthera Onca",
		"Habitat": "Bosque",
		"Actividad": "Diurno",
		"Socialidad": "Solitario",
		"Interactuable": ["Habitat", "Socialidad"]
	},
	{
		"Nombre": "Hippocamelus Bisulcus",
		"Habitat": "Bosque",
		"Actividad": "Diurno",
		"Socialidad": "Solitario",
		"Interactuable": ["Socialidad"]
	},
	{
		"Nombre": "Tyto Alba",
		"Habitat": "Bosque",
		"Actividad": "Nocturno",
		"Socialidad": "Solitario",
		"Interactuable": ["Actividad", "Socialidad"]
	},
	{
		"Nombre": "Chonchón",
		"Habitat": "Cueva",
		"Actividad": "Nocturno",
		"Socialidad": "Grupal",
		"Interactuable": ["Habitat", "Actividad", "Socialidad"]
	},
	{
		"Nombre": "Caimán Yacaré",
		"Habitat": "Lago",
		"Actividad": "Diurno",
		"Socialidad": "Grupal",
		"Interactuable": ["Habitat", "Actividad"]
	},
	{
		"Nombre": "Nahuelito",
		"Habitat": "Lago",
		"Actividad": "Nocturno",
		"Socialidad": "Solitario",
		"Interactuable": ["Habitat", "Actividad","Socialidad"]
	},
	{
		"Nombre": "Nyctibius Griseus",
		"Habitat": "Monte",
		"Actividad": "Diurno",
		"Socialidad": "Solitario",
		"Interactuable": ["Socialidad"]
	},
	{
		"Nombre": "Priodontes Maximus",
		"Habitat": "Monte",
		"Actividad": "Diurno",
		"Socialidad": "Solitario",
		"Interactuable": ["Habitat"]
	},
	{
		"Nombre": "Chancha con Cadenas",
		"Habitat": "Monte",
		"Actividad": "Nocturno",
		"Socialidad": "Solitario",
		"Interactuable": ["Actividad", "Socialidad"]
	},
	{
		"Nombre": "Hydrochoerus Hydrochaeris",
		"Habitat": "Pradera",
		"Actividad": "Diurno",
		"Socialidad": "Grupal",
		"Interactuable": ["Actividad"]
	},
	{
		"Nombre": "Aguará Guazú",
		"Habitat": "Pradera",
		"Actividad": "Nocturno",
		"Socialidad": "Solitario",
		"Interactuable": ["Actividad", "Socialidad"]
	}
]

@export var category_options: Dictionary = {
	"Habitat": ["Bosque", "Pradera", "Monte", "Lago", "Cueva"],
	"Actividad": ["Día", "Noche"],
	"Socialidad": ["Solitario", "Grupal"]
}
var categoryElements = {
	"Habitat": {
		"button": "Panel/VBoxContainer/Habitat/Habitat_OptionButton",
		"label": "Panel/VBoxContainer/Habitat/HabitatLabel"
		},
	"Actividad": {
		"button": "Panel/VBoxContainer/Actividad/Actividad_OptionButton",
		"label": "Panel/VBoxContainer/Actividad/ActividadLabel"
		},
	"Socialidad": {
		"button": "Panel/VBoxContainer/Socialidad/Socialidad_OptionButton",
		"label": "Panel/VBoxContainer/Socialidad/SocialidadLabel"
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
	for category in category_options.keys():
		var button: OptionButton = get_node_or_null(categoryElements[category]["button"])
		var label: Label = get_node_or_null(categoryElements[category]["label"])
		
		if button and label:
			button.clear()
			for option in category_options[category]:
				button.add_item(option)
			
			var esInteractuable = category in animal["Interactuable"]
			button.visible = esInteractuable
			label.visible = not esInteractuable
			
			if not esInteractuable:
				label.text = animal[category]
			
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

func next_animal():
	if currentAnimalIndex < animals.size() -1:	
		currentAnimalIndex += 1
		update_ui()

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
	
