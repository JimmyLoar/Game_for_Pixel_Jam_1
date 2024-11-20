@tool
class_name MinerPanel
extends PanelContainer

@export_enum("Unpurchased:0", "Disable:1", "Enable:2") var mode := 0

var database: Database = load(ProjectSettings.get_setting("resource_databases/main_path", ""))

@onready var prise_display_container: HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer3
@onready var button: Button = $MarginContainer/VBoxContainer/HBoxContainer2/Button
@onready var recipe_display: VBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer

@onready var progress_bar: TextureProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/TextureProgressBar
@onready var timer: Timer = $Timer
@onready var rich_text_label: RichTextLabel = $MarginContainer/VBoxContainer/HBoxContainer2/RichTextLabel
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	if Engine.is_editor_hint(): 
		return
	
	UpgradedList.changed_list.connect(_update_lock)
	Properties.change_value.connect(_update_property)
	timer.timeout.connect(_on_timeout)
	_update_lock()



func update_prise_display():
	for i in range(3):
		var child: PriseDisplay = prise_display_container.get_node("PriseDisplay%d" % [i + 1])
		if not child: continue
		child.update(prises[i * 2])
		child.prise = prises[i * 2 + 1]
	pass


func check_for_unlock():
	var _names = need_upgrade_names
	var _levels = need_upgrade_levels
	for i in _names.size():
		if not UpgradedList.upgrade_is_more_level(_names[i], _levels[i]):
			return false
	return true


func _update_lock():
	if check_for_unlock(): 
		rich_text_label.clear()
		rich_text_label.append_text(TranslationServer.translate("MINER_DISCRIPTION"))
		button.disabled = false
		button.text = TranslationServer.translate("BUTTON_TEXT_BUY")
		update_prise_display()
		
	else:
		prise_display_container.get_child(0).hide()
		prise_display_container.get_child(1).hide()
		prise_display_container.get_child(2).hide()
		rich_text_label.clear()
		rich_text_label.append_text("[color=red]%s[/color]" % TranslationServer.translate("UPGRADE_LOCK_TEXT"))
		for index in need_upgrade_names.size():
			rich_text_label.append_text("\n%s %d" % [
				TranslationServer.translate("UPGRADE_NAME_%s" % need_upgrade_names[index].to_upper()), 
				need_upgrade_levels[index],
				])
		button.disabled = true
		button.text = TranslationServer.translate("BUTTON_TEXT_LOCK")


func _on_button_pressed() -> void:
	match mode:
		0: _on_pressed_pushased()
		1: _on_pressed_selected()
		2: _on_pressed_selected()
		_: push_error("unvalide miner mode '%d'" % mode)


func _on_pressed_pushased():
	if not check_for_currency():
		audio_player.play_sound("error")
		return
	
	audio_player.play_sound("conf")
	pushase()
	

func check_for_currency():
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
	button.text = TranslationServer.translate("BUTTON_TEXT_SELECTE_RECIPE")
	$MarginContainer/VBoxContainer/HBoxContainer2/RichTextLabel.text = TranslationServer.translate("MINER_SELECT_RECIPE")


func _on_pressed_selected():
	audio_player.play_sound("select")
	button.text = TranslationServer.translate("BUTTON_TEXT_CHANGE_RECIPE")
	var selecter = $"../../../../../../RecipeSelecter"
	selecter.recipe_selected.connect(_confirm_selected, CONNECT_ONE_SHOT)
	selecter.show()
	

var _selected_recipe: RecipeI
func _confirm_selected(recipe: RecipeI):
	audio_player.play_sound("select")
	_selected_recipe = recipe
	$MarginContainer/VBoxContainer/HBoxContainer2/RichTextLabel.hide()
	recipe_display.recipe = recipe
	recipe_display.update()
	recipe_display.show()
	progress_bar.show()
	mode = 2
	
	if recipe.execution_time == 0:
		timer.stop()
		progress_bar.hide()
	
	else:
		var time = _get_execution_time()
		timer.start(time)
		progress_bar.max_value = time
		progress_bar.show()


func _get_execution_time():
	if not _selected_recipe:
		return 0
	return _selected_recipe.execution_time / (Properties.get_value("mining_speed") / 10.0)


func _on_timeout():
	var resource = _selected_recipe.get_resource()
	if not check_currency(resource):
		return
	
	for i in resource.size() / 2:
		var multiper = Properties.get_value("mining_reward") if i > 2 else -1
		var value = resource[i * 2 +1] * multiper
		Currency.add_value_id(resource[i * 2], value)
	audio_player.play_sound("mining%d" % [randi() % 5])


func _update_property(_name: String):
	if _name != "mining_speed":
		return
	
	var time = _get_execution_time()
	timer.wait_time = time
	progress_bar.max_value = time


func check_currency(resource: Array) -> bool:
	for i in range(3):
		var prise = resource[i * 2 + 1]
		if prise == 0: 
			continue
		
		var _id = resource[i * 2]
		if not Currency.has_value_for_id(_id, prise):
			return false
	return true


func set_title(_name: String):
	$MarginContainer/VBoxContainer/HBoxContainer/TitleLabel.text = _name



@export_group("Prise", "_prise_")
const PRISES_PROPERTIES_AMOUNT = 2
var prises := Array([1, 0, 1, 0, 1, 0])
var need_upgrade_names = PackedStringArray()
var need_upgrade_levels = PackedInt32Array()

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = [] 
	for i in range(3):
		properties.append(PropertiesHelper.get_currency_id(database, "_prise_%s_id" % i))
		properties.append(PropertiesHelper.get_int_range("_prise_%s_value" % i,
			0, 1000, 1, PropertiesHelper.Outrange.GREATER))
	
	properties.append({
		name = "need_upgrade_names",
		type = TYPE_PACKED_STRING_ARRAY,
	})
	
	properties.append({
		name = "need_upgrade_levels",
		type = TYPE_PACKED_INT32_ARRAY,
	})
	
	return properties


func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with("_prise"):
		var index = property.to_int()
		var offset = convert(property.ends_with("value"), TYPE_INT)
		prises[index * PRISES_PROPERTIES_AMOUNT + offset] = value
		return true
	return false


func _get(property: StringName) :
	if property.begins_with("_prise"):
		var index = property.to_int()
		var offset = convert(property.ends_with("value"), TYPE_INT)
		return prises[index * PRISES_PROPERTIES_AMOUNT + offset]
	
