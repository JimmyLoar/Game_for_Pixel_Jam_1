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
var _unlock := true

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	update()
	_update_prise()
	if data:
		level_up.connect(UpgradedList.on_level_up.bind(data.name_key))
		UpgradedList.changed_list.connect(update)


func update():
	if not data: return
	title_label.text = data.visible_name + " %d" % currect_level
	texture_rect.texture = data.texture
	rich_text_label.clear()
	_unlock = check_for_unlock()
	if _unlock:
		var values = data.get_values(currect_level)
		rich_text_label.append_text(data.discription.format(values))
		_update_prise()
	
	else:
		_update_lock()
	


func _update_prise():
	if not data or is_max_level(): 
		_update_prise_null()
		return
	
	var _level_data = data.level_list[currect_level]
	for i in range(3):
		var display: PriseDisplay = prises.get_child(i)
		display.set_id(_level_data["prise_%d/id" % i])
		display.prise = _level_data["prise_%d/value" % i] 
	button.text = TranslationServer.translate("BUTTON_TEXT_BUY")
	button.disabled = not _unlock


func _update_prise_null():
	for i in range(3):
		var display = prises.get_child(i)
		display.set_id(1)
		display.prise = 0
	button.disabled = true
	button.text = TranslationServer.translate("BUTTON_TEXT_MAX")


func _update_lock():
	var _names = data.get_need_names(currect_level)
	var _levels = data.get_need_levels(currect_level)
	rich_text_label.clear()
	rich_text_label.append_text("[color=red]%s[/color]" % TranslationServer.translate("UPGRADE_LOCK_TEXT"))
	for index in _names.size():
		rich_text_label.append_text("\n%s %d" % [
			TranslationServer.translate("UPGRADE_NAME_%s" % _names[index].to_upper()), 
			_levels[index],
			])
	#rich_text_label.append_text("[/color]")
	button.disabled = true
	button.text = TranslationServer.translate("BUTTON_TEXT_LOCK")
	


func check_for_unlock():
	var _names = data.get_need_names(currect_level)
	var _levels = data.get_need_levels(currect_level)
	for i in _names.size():
		#breakpoint
		if not UpgradedList.upgrade_is_more_level(_names[i], _levels[i]):
			return false
	return true


func _on_button_pressed() -> void:
	if not check_currency():
		return
	
	for i in range(3):
		var display: PriseDisplay = prises.get_child(i)
		Currency.add_value(display._name, display.prise * -1)
	
	currect_level = clamp(currect_level + 1, 0, data.level_max)
	var values = data.get_values(currect_level)
	if data.add_property:
		for key in values.keys():
			Properties.set_value(key, values[key])
	_update_prise()
	update()
	level_up.emit(currect_level, data.level_max, data.get_values(currect_level))
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
