extends PanelContainer


func _on_recycle_clicked() -> void:
	pass # Replace with function body.


func _on_extraction_clicked() -> void:
	var value = Properties.get_value("drop_per_click")
	Currency.add_value("pixel_empty", value)
	#_rare_value += value
	#_super_value += value
	#add_rare()
	#add_super()

var _rare_value = 0
const _names := ["pixel_red", "pixel_green", "pixel_blue"]
func add_rare():
	var value = floori(_rare_value / 200)
	Currency.add_value(_names[randi_range(0, 2)], value)
	_rare_value -= value * 200


var _super_value = 0
func add_super():
	var value = floori(_super_value / 2000)
	Currency.add_value("pixel_super", value)
	_super_value -= value * 2000
