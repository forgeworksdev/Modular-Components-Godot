class_name InventorySlot
extends Resource

@export var stored_item: InventoryItem
@export var count: int = 0
#@export var metadata: Dictionary = {}

func is_empty() -> bool:
	return stored_item == null

func clear() -> void:
	stored_item = null
	count = 0
	#metadata.clear()

func max_stack_size() -> int:
	if stored_item == null:
		return 0
	return stored_item.stack_size

func remaining_space() -> int:
	return max(0, max_stack_size() - count)

func is_full() -> bool:
	return not is_empty() and count == max_stack_size()

#FIXME Implement item instance
func insert(new_item: InventoryItem, amount: int) -> void:
	if amount <= 0:
		push_error("InventorySlot: Invalid amount!")

	if is_empty():
		stored_item = new_item
		count = amount

	var space: int = remaining_space()
	count += min(space, amount)

func remove(amount: int) -> void:
	if amount <= 0 or is_empty():
		return

	count = max(count - amount, 0)

	if count == 0:
		clear()

func can_merge(other: InventorySlot) -> bool:
	if other.is_empty():
		return false
	if is_empty():
		return true
	if stored_item != other.stored_item:
		return false
	return count < max_stack_size()


func merge_from(other: InventorySlot) -> int:
	if not can_merge(other):
		return 0

	var space: int = remaining_space()
	var absorbed: int = min(space, other.count)

	count += absorbed
	other.count -= absorbed

	if other.count <= 0:
		other.clear()

	return absorbed

func to_dict() -> Dictionary:
	return {
		"stored_item": stored_item,
		"count": count
		#"metadata": metadata
	}

#func from_dict(data: Dictionary) -> void:
	#stored_item = data.get("stored_item", "")
	#count = data.get("count", 0)
	#metadata = data.get("metadata", {}).duplicate(true)
