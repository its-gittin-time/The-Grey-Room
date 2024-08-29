extends WorldEnvironment

func _ready() -> void:
	if OS.get_name() == "Web":
		environment.ssao_enabled = true
