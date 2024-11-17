@tool
class_name MinerPanel
extends PanelContainer

@export_enum("Unpurchased:0", "Disable:1", "Enable:2") var mode := 0

var database: Database = load(ProjectSettings.get_setting("resource_databases/main_path", ""))

@onready var prise_display_container: HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer
@onready var button: Button = $MarginContainer/VBoxContainer/HBoxContainer2/Button
@onready var progress_bar: TextureProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/TextureProgressBar


func _ready() -> void:
	if Engine.is_editor_hint(): 
		return
	update_prise_display()


func update_prise_display():
	for i in range(3):
		var child: PriseDisplay = prise_display_container.get_node("PriseDisplay%d" % [i + 1])
		if not child: continue
		child.update(prises[i * 2])
		child.prise = prises[i * 2 + 1]
	pass


func _on_button_pressed() -> void:
	match mode:
		0: _on_pressed_pushased()
		1: _on_pressed_pushased()
		2: _on_pressed_pushased()
		_: push_error("unvalide miner mode '%d'" % mode)


func _on_pressed_pushased():
	if not check_for_unlock():
		return
	pushase()
	

func check_for_unlock():
	for i in range(3):
		if not Currency.has_value_for_id(prises[i * 2], prises[i * 2 + 1]):
			return false
	return true


func pushase():
	for i in range(3):
		var index = i * PRISES_PROPERTIES_AMOUNT
		Currency.add_value_id(prises[index], prises[index + 1] * -1)
	
	mode = 1
	prises.fill(0)
	update_prise_display()
	button.text = "select recipe"
	$MarginContainer/VBoxContainer/HBoxContainer2/RichTextLabel.text = TranslationServer.translate("MINER_SELECT_RECIPE")


func set_title(_name: String):
	$MarginContainer/VBoxContainer/HBoxContainer/TitleLabel.text = _name



@export_group("Prise", "_prise_")
const PRISES_PROPERTIES_AMOUNT = 2
var prises := Array([1, 0, 1, 0, 1, 0])

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = [] 
	for i in range(3):
		properties.append(PropertiesHelper.get_currency_id(database, "_prise_%s_id" % i))
		properties.append(PropertiesHelper.get_int_range("_prise_%s_value" % i,
			0, 1000, 1, PropertiesHelper.Outrange.GREATER))
	return properties


func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with("_prise"):
		var index = property.to_int()
		var offset = convert(property.ends_with("value"), TYPE_INT)
		prises[index * PRISES_PROPERTIES_AMOUNT + offset] = value
		return true
	return false


func _get(property: StringName) -> Variant:
	if property.begins_with("_prise"):
		var index = property.to_int()
		var offset = convert(property.ends_with("value"), TYPE_INT)
		return prises[index * PRISES_PROPERTIES_AMOUNT + offset]
	return 
