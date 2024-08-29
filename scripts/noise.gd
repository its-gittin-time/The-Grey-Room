extends TextureRect

var delta_count := 0.0

func _process(delta: float) -> void:
	if delta_count >= 1.0/24 :
		texture.noise.seed += 1
		delta_count = 0
	else:
		delta_count += delta
