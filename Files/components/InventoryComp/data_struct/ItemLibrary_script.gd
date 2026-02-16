## Central item definition collection.
class_name ItemLibrary
extends Resource

@export var items: Array[InventoryItem]

var lookup: Dictionary[StringName, InventoryItem] = {}

#This is one of three solutions to item saving. Allows saving an ID and then retrieving the resource corresponding to it

func build_lookup() -> void:
	lookup.clear()
	for i in items:
		lookup[i.id] = i

func get_item(id: StringName) -> InventoryItem:
	return lookup.get(id)
