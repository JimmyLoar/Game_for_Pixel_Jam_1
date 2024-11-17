extends Node

signal changed_list

var _list = {}

func on_level_up(currect_level: int, _max_level: int, _values := {}, upgrade_name: String = ""):
	_list[upgrade_name] = currect_level
	changed_list.emit()


func upgrade_is_more_level(_name: String, level: int):
	if not _list.has(_name):
		return false
	return _list[_name] >= level


func get_level(_name: String):
	if _list.has(_name):
		return _list[_name]
	return 0
