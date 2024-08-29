extends Node3D

func _ready() -> void:
	$button_3d.push_result = Callable(func() -> void:
		if check_wires():
			if not $door2.is_open:
				$door2.open()
				$button_3d/win.play()
		else:
			$incorrect.show()
			$button_3d/fail.play()
			await get_tree().create_timer(1.0).timeout
			$incorrect.hide())

var time_elapsed := 1200.0
var minutes : float
var seconds : float
var time_string : String

func _process(delta: float) -> void:
	if time_elapsed <= 0:
		time_elapsed = 600.0
		$explosion.play()
	time_elapsed -= delta
	minutes = floor(time_elapsed / 60)
	seconds = floor(fmod(time_elapsed, 60))
	$countdown.text = "%02d:%02d" % [minutes, seconds]

func check_wires() -> bool:
	for lock in $locks.get_children():
		if not lock.correct_wire():
			return false
	return true
