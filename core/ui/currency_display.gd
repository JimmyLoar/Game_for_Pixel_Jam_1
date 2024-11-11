@tool
class_name CurrencyDisplay
extends MarginContainer

@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var label: Label = $HBoxContainer/Label
var database: Database = load(ProjectSettings.get_setting("resource_databases/main_path", ""))

var _id: int = 1:
	set(value):
		_id = value
		_name = database.fetch_data("currency", _id).name_key
var _name: String = ""

func _ready() -> void:
	Currency.change_value.connect(update_value)
	update(_name)
	update_value(_name)


func update(property_name = ""):
	if property_name == "": 
		hide()
		return
	
	var data: CurrencyData = Currency.get_data(property_name)
	texture_rect.texture = data.texture
	modulate = data.modulate
	tooltip_text = data.visible_name
	show()


func update_value(currency_name: String):
	if _name != currency_name:
		return 
	
	var value = Currency.get_value(_name)
	label.text = "".humanize_size(value)
	visible = value > 0


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = [] 
	var name_hint = PROPERTY_HINT_NONE
	var name_string = ""
	if Engine.is_editor_hint():
		var props = database.fetch_collection_data("currency") as Dictionary
		var _names = PackedStringArray(props.values().map(
			func(element: CurrencyData):
				return "%s:%d" % [element.name_key, props.find_key(element)]
		))
		name_hint = PROPERTY_HINT_ENUM
		name_string = ", ".join(_names)
	
	properties.append({
		name = "_id",
		type = TYPE_INT,
		hint = name_hint,
		hint_string = name_string,
	})
	
	return properties
