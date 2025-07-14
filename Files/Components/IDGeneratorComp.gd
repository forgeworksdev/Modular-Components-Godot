## Generates sequential IDs.
class_name IDGenerator extends Node

var _next_id: int = 1 # Start from 1, reserve 0 for special cases

func generate_id() -> int:
	var id: int = _next_id
	_next_id += 1
	print("New ID generated: %s" % id)
	return id

func reset_id() -> void:
	_next_id = 1
