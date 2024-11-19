extends "res://core/script/singletone/currency.gd"

const INIT_PROPERTIES = {
	"drop_per_click": 1,
	
	"mining_speed": 10,
	"mining_reward": 1,
	
	"": 0,
}

func _init() -> void:
	_values = INIT_PROPERTIES.duplicate()
