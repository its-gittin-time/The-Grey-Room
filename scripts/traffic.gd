extends Node3D

const car := preload("res://scenes/car.tscn")
var stopped := false

func _ready() -> void:
	Car.reset_point = $spawn.global_position
	if OS.get_name() == "Web":
		$fog_volume.hide()
		$fog_volume2.hide()
	else:
		$fake_fog.hide()
		$fake_fog2.hide()
		$fake_fog3.hide()
		$fake_fog4.hide()

func _on_timer_timeout() -> void:
	if stopped: return
	if randf() > 0.5:
		if randf() > 0.5:
			$first_spawn1.add_child(car.instantiate())
		else:
			$first_spawn2.add_child(car.instantiate())
	else:
		if randf() > 0.5:
			$second_spawn1.add_child(car.instantiate())
		else:
			$second_spawn2.add_child(car.instantiate())

var time_elapsed := 0.0
var minutes : float
var seconds : float
var time_string : String
var counting := true

func _process(delta: float) -> void:
	if counting:
		time_elapsed += delta
		minutes = floor(time_elapsed / 60)
		seconds = floor(fmod(time_elapsed, 60))
		$stopwatch.text = "%02d:%02d" % [minutes, seconds]

func _on_complete_zone_body_entered(body: Node3D) -> void:
	if body is Bean:
		if not $door2.is_open:
			$door2.open()
			counting = false
			stopped = true
			$green_duration.paused = true
			$orange_duration.paused = true
			$red_duration.paused = true

enum LIGHT_CODES {
	GREEN_LIGHT,
	ORANGE_LIGHT,
	RED_LIGHT
}

func _on_green_duration_timeout() -> void:
	$orange_duration.start()

	$traffic_light.change_lights(LIGHT_CODES.ORANGE_LIGHT)
	$traffic_light2.change_lights(LIGHT_CODES.ORANGE_LIGHT)


func _on_orange_duration_timeout() -> void:
	$red_duration.start()
	stopped = true
	$traffic_light.change_lights(LIGHT_CODES.RED_LIGHT)
	$traffic_light2.change_lights(LIGHT_CODES.RED_LIGHT)

func _on_red_duration_timeout() -> void:
	$green_duration.start()
	stopped = false
	if randf() < 0.6:
		$second_spawn2.add_child(car.instantiate())
	$traffic_light.change_lights(LIGHT_CODES.GREEN_LIGHT)
	$traffic_light2.change_lights(LIGHT_CODES.GREEN_LIGHT)

func switcharoo() -> void:
	#TrafficLight.lights.shuffle()
	var my_array : Array[StandardMaterial3D] = [TrafficLight.green, TrafficLight.orange, TrafficLight.red]
	my_array.shuffle()
	TrafficLight.lights = my_array
	#print(TrafficLight.lights)
	#print(my_array)
	$traffic_light.update_lights()
	$traffic_light2.update_lights()
	if $green_duration.time_left:
		$traffic_light.change_lights(LIGHT_CODES.GREEN_LIGHT)
		$traffic_light2.change_lights(LIGHT_CODES.GREEN_LIGHT)
	elif $orange_duration.time_left:
		$traffic_light.change_lights(LIGHT_CODES.ORANGE_LIGHT)
		$traffic_light2.change_lights(LIGHT_CODES.ORANGE_LIGHT)
	elif $red_duration.time_left:
		$traffic_light.change_lights(LIGHT_CODES.RED_LIGHT)
		$traffic_light2.change_lights(LIGHT_CODES.RED_LIGHT)
