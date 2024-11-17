@static_unload
class_name PropertiesHelper



static func get_currency_id(database: Database, _name: String = "_id") -> Dictionary:
	var _hint = PROPERTY_HINT_NONE
	var _hint_string = ""
	if Engine.is_editor_hint():
		var props = database.fetch_collection_data("currency") as Dictionary
		var _names = PackedStringArray(props.values().map(
			func(element: CurrencyData):
				return "%s:%d" % [element.name_key, props.find_key(element)]
		))
		_hint = PROPERTY_HINT_ENUM
		_hint_string = ", ".join(_names)
	
	return {
		name = _name,
		type = TYPE_INT,
		hint = _hint,
		hint_string = _hint_string,
	}


static func get_currency_name(database: Database, _name: String = "_id") -> Dictionary:
	var _hint = PROPERTY_HINT_NONE
	var _hint_string = ""
	if Engine.is_editor_hint():
		var props = database.fetch_collection_data("currency") as Dictionary
		var _names = PackedStringArray(props.values().map(
			func(element: CurrencyData):
				return "%s:%d" % [element.name_key, props.find_key(element)]
		))
		_hint = PROPERTY_HINT_ENUM
		_hint_string = ", ".join(_names)
	
	return {
		name = _name,
		type = TYPE_INT,
		hint = _hint,
		hint_string = _hint_string,
	}


enum Outrange{
	NONE,
	GREATER,
	LESS,
}
static func get_int_range(_name: String, min: int = 0, max: int = 1, step: int = 1, outrange_ind: Outrange = Outrange.NONE):
	var outrange = {
		Outrange.NONE: "",
		Outrange.GREATER: ",or_greater",
		Outrange.LESS: ",or_less",
	}[outrange_ind]
	return {
		name = _name,
		type = TYPE_INT,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "%d,%d,%d%s" % [min, max, step, outrange],
	}
