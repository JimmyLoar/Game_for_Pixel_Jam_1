@tool
class_name RecipeCraft
extends RecipeI


var resources := Array([0, 2, 1, 0, 1, 0, 2, 1])
const RESOURCE_PROPERTIES_AMOUNT = 2


func get_resource():
	return resources


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = [] 
	for i in range(4):
		properties.append(PropertiesHelper.get_currency_id(database, "_resource_%s_id" % i))
		properties.append(PropertiesHelper.get_int_range("_resource_%s_value" % i,
			0, 1000, 1, PropertiesHelper.Outrange.GREATER))
	return properties


func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with("_resource"):
		var index = property.to_int()
		var offset = convert(property.ends_with("value"), TYPE_INT)
		resources[index * RESOURCE_PROPERTIES_AMOUNT + offset] = value
		return true
	return false


func _get(property: StringName) -> Variant:
	if property.begins_with("_resource"):
		var index = property.to_int()
		var offset = convert(property.ends_with("value"), TYPE_INT)
		return resources[index * RESOURCE_PROPERTIES_AMOUNT + offset]
	return 
