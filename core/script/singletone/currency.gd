extends Node

signal change_value(currency_name: String)

const COLLECTION_NAME = "currency"

var database: Database = load(ProjectSettings.get_setting("resource_databases/main_path", ""))

var _values := Dictionary({
	#"pixel_empty": 1000000,
})


func _init() -> void:
	var currency_list = database.fetch_collection_data(COLLECTION_NAME)
	for data in currency_list.values():
		if _values.has(data.name_key): continue
		set_value(data.name_key, data.default_value)


func set_value(currency_name: String, value: int):
	_values[currency_name] = value
	change_value.emit(currency_name)


func add_value(currency_name: String, value: int = 0):
	set_value(currency_name, get_value(currency_name) + value)


func add_value_id(id: int, value: int = 0):
	return add_value(get_name_from_id(id), value)


func has_value(currency_name: String, value: int):
	return get_value(currency_name) >= value


func has_value_for_id(id: int, value: int):
	return has_value(get_name_from_id(id), value)


func get_value(currency_name: String) -> int:
	if _values.has(currency_name):
		return _values[currency_name]
	return 0


func get_name_from_id(id: int):
	return database.fetch_data(COLLECTION_NAME, id).name_key


func get_data(currency_name):
	if typeof(currency_name) == TYPE_STRING:
		return database.fetch_data_string("%s/%s" % [COLLECTION_NAME, currency_name])
	elif typeof(currency_name) == TYPE_INT:
		return database.fetch_data(COLLECTION_NAME, currency_name)
	return null
