@tool
class_name UpgradeData
extends Resource



@export_placeholder("enter name") var name_key: String = 'upgrade_name':
	set(value):
		name_key = value.to_lower()
		visible_name = TranslationServer.translate("UPGRADE_NAME_" + name_key.to_upper())
		discription = TranslationServer.translate("UPGRADE_DISCRIPTION_" + name_key.to_upper())

@export_custom(	PROPERTY_HINT_MULTILINE_TEXT, "", 
	PROPERTY_USAGE_READ_ONLY + PROPERTY_USAGE_DEFAULT
	) var visible_name: String = "":
		get(): return TranslationServer.translate("UPGRADE_NAME_" + name_key.to_upper())
@export_custom(PROPERTY_HINT_MULTILINE_TEXT, "", 
	PROPERTY_USAGE_READ_ONLY + PROPERTY_USAGE_DEFAULT
	) var discription : String = "":
		get(): return TranslationServer.translate("UPGRADE_DISCRIPTION_" + name_key.to_upper())

@export var texture: Texture2D
@export var is_override := false

@export_range(1, 50, 1, "or_greater") var level_max := 1:
	set(value):
		level_max = value
		level_list.resize(value + 1)
		notify_property_list_changed()
var level_list: Array[Dictionary] = []
@export var values_names: Array[String] = ["defualt"]

var database: Database = load(ProjectSettings.get_setting("resource_databases/main_path", ""))


func get_values(level: int):
	level = clamp(level, 0, level_max)
	var keys = level_list[level].keys().map(
		func(element: String): 
			if element.begins_with("values"):
				return element.get_slice("/", 1)
			return "")
	var values = {}
	for key in keys:
		if key == '': continue
		values[key] = level_list[level]["values/%s" % key]
	return values


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	var props = database.fetch_collection_data("currency") as Dictionary
	var _names = PackedStringArray(props.values().map(
		func(element: CurrencyData):
			return "%s:%d" % [element.name_key, props.find_key(element)]
	))
	
	for i in level_max + 1:
		for key in values_names:
			var _type = TYPE_INT 
			if key.contains(":"):
				_type = key.get_slice(":", 1).to_int()
				key = key.get_slice(":", 0)
			
			properties.append({
				name = "level_%02d/values/%s" % [i, key],
				type = _type,
				hint = PROPERTY_HINT_RANGE,
				hint_string = "0, 65536, 1, or_greater",
			})
		
		for ii in range(3):
			properties.append({
				name = "level_%02d/prise_%d/id" % [i, ii],
				type = TYPE_INT,
				hint = PROPERTY_HINT_ENUM,
				hint_string = ", ".join(_names).capitalize(),
			})
			properties.append({
				name = "level_%02d/prise_%d/value" % [i, ii],
				type = TYPE_INT,
				hint = PROPERTY_HINT_RANGE,
				hint_string = "0, 65536, 1, or_greater",
			})
	return properties


func _get(_name: StringName):
	if not _name.begins_with("level"):
		return
	
	var splited := _name.split("/", true, 1)
	var level = splited[0].to_int()
	var value_name = splited[1]
	
	if level_list[level].has(value_name):
		return level_list[level][value_name]
	
	return 0


func _set(_name: StringName, value):
	if not _name.begins_with("level"):
		return false
	
	var splited := _name.split("/", true, 1)
	var level = splited[0].to_int()
	var value_name = splited[1]
	
	if not level_list[level]:
		level_list[level] = {}
	
	if value_name.begins_with("values"):
		var index = level
		while index <= level_max and is_override:
			level_list[index][value_name] = value
			index += 1
	
	if value_name.ends_with("id"):
		var index = level
		while index <= level_max and is_override:
			level_list[index][value_name] = value
			index += 1
	
	level_list[level][value_name] = value
	return true
