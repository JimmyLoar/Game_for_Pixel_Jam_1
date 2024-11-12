extends "res://core/script/singletone/currency.gd"

const INIT_PROPERTIES = {
	"drop_per_click": 1,
	
	"weight_rare_group_1": 90,
	"weight_rare_group_2": 9,
	"weight_rare_group_4": 1,
	"bonus_rare_group_1": 1.0,
	"bonus_rare_group_2": 1.0,
	"bonus_rare_group_4": 1.0,
	
	"": 0,
}

func _init() -> void:
	_values = INIT_PROPERTIES.duplicate()
