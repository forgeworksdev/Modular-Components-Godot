## A "database" for storing [InventorySlot].
@tool
class_name InventoryDatabase extends Resource

## Amount of slots this [InventoryDatabase] stores.
@export var slot_count: int = 10:
	set(value):
		slot_count = max(0, value)
		_resize_slots(slot_count)

## Array that holds [InventorySlot].
@export var slots: Array[InventorySlot]

func _resize_slots(new_size: int) -> void:
	slots.resize(new_size)
	for i in range(slots.size()):
		if slots[i] == null:
			slots[i] = InventorySlot.new()
