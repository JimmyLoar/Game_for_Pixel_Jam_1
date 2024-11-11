extends Node

signal change_value(currency_name: String)

const COLLECTION_NAME = "currency"

var database: Database = load(ProjectSettings.get_setting("resource_databases/main_path", ""))

var _values := Dictionary()


func _ready() -> void:
	var currency_list = database.fetch_collection_data(COLLECTION_NAME)
	for data in currency_list.values():
		set_value(data.name_key, data.default_value)


func set_value(currency_name: String, value: int):
	_values[currency_name] = value
	change_value.emit(currency_name)


func add_value(currency_name: String, value: int = 0):
	set_value(currency_name, get_value(currency_name) + value)


func has_value(currency_name: String, value: int):
	return get_value(currency_name) >= value


func get_value(currency_name: String) -> int:
	if _values.has(currency_name):
		return _values[currency_name]
	return 0


func get_data(currency_name: String):
	return database.fetch_data_string("currency/%s" % currency_name)
	
