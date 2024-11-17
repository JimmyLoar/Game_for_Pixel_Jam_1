@tool
class_name RecipeExtract
extends RecipeI

var _id: int = 1:
	set(value):
		_id = value
		_name = database.fetch_data("currency", _id).name_key
var _name: String = ""


func get_resource():
	return [_id, 1]


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
