class_name InventoryData extends Resource

var size: int = 10:
	set(value):
		slots.resize(size)
		size = value

@export var slots: Array[InventorySlot] = []
