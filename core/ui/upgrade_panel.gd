@tool
extends PanelContainer

signal level_up

@export var data: UpgradeData

@onready var prises: HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer/Prise
@onready var title_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var texture_rect: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer2/TextureRect
@onready var rich_text_label: RichTextLabel = $MarginContainer/VBoxContainer/HBoxContainer2/RichTextLabel
@onready var button: Button = $MarginContainer/VBoxContainer/HBoxContainer2/Button

var currect_level = 0


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	update()
	_update_prise()


func update():
	if not data: return
	title_label.text = data.visible_name
	texture_rect.texture = data.texture
	rich_text_label.clear()
	var values = data.get_values(currect_level)
	rich_text_label.append_text(data.discription.format(values))
	


func _update_prise():
	if not data or is_max_level(): 
		_update_prise_null()
		return
	
	var _level_data = data.level_list[currect_level]
	for i in range(3):
		var display: PriseDisplay = prises.get_child(i)
		display.set_id(_level_data["prise_%d/id" % i])
		display.prise = _level_data["prise_%d/value" % i] 
	
	button.disabled = false


func _update_prise_null():
	for i in range(3):
		var display = prises.get_child(i)
		display.set_id(1)
		display.prise = 0
	button.disabled = true
	button.text = "MAX"


func _on_button_pressed() -> void:
	if not check_currency():
		return
	
	for i in range(3):
		var display: PriseDisplay = prises.get_child(i)
		Currency.add_value(display._name, display.prise * -1)
	
	currect_level = clamp(currect_level + 1, 0, data.level_max)
	var values = data.get_values(currect_level)
	for key in values.keys():
		Properties.set_value(key, values[key])
	_update_prise()
	update()
	level_up.emit(currect_level, data.level_max)
	return


func is_max_level():
	return currect_level >= data.level_max


func check_currency() -> bool:
	for display: PriseDisplay in prises.get_children():
		if display.prise == 0: 
			continue
		if not display.check_has_prise():
			return false
	return true
