extends WorldEnvironment

## Duración del ciclo en segundos
@export var cycle_duration: float = 60.0 

@onready var sun: MeshInstance3D = $SunMoon/Sun
@onready var moon: MeshInstance3D = $SunMoon/Moon
@onready var sunLight: DirectionalLight3D = $SunMoon/Sun/SunLight
@onready var moonLight: DirectionalLight3D = $SunMoon/Moon/MoonLight
@onready var sunMoon: Node3D = $SunMoon


var time_passed: float = 0.0

func _process(delta):
	if cycle_duration > 0:
		time_passed += delta
		var cycle_progress = fmod(time_passed / cycle_duration, 1.0) # Normalize to 0-1 range

		# Rotate the sun and moon based on the cycle progress
		var angle = cycle_progress * 360.0 # Convert progress to degrees
		sunMoon.rotation_degrees.x = angle


#		# Adjust light intensity based on time of day
#		if cycle_progress < 0.5: # Daytime
#			sunLight.light_energy = lerp(0.0, 1.0, cycle_progress * 2.0)
#			moonLight.light_energy = lerp(1.0, 0.0, cycle_progress * 2.0)
#		else: # Nighttime
#			sunLight.light_energy = lerp(1.0, 0.0, (cycle_progress - 0.5) * 2.0)
#			moonLight.light_energy = lerp(0.0, 1.0, (cycle_progress - 0.5) * 2.0)

		
