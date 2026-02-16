class_name InventoryComponent extends Node

@export var Data: InventoryData

signal inventory_changed
signal slot_changed(index: int)
signal item_added(item: InventoryItem, amount: int)
signal item_removed(item: InventoryItem, amount: int)

func slot_count() -> int:
	return Data.slots.size()

func get_slot(index: int) -> InventorySlot:
	return Data.slots[index]

func has_item(item: InventoryItem, amount: int = 1) -> bool:
	var total := 0
	for slot in Data.slots:
		if slot.stored_item == item:
			total += slot.count
			if total >= amount:
				return true
	return false

func get_total_count(item: InventoryItem) -> int:
	var total := 0
	for slot in Data.slots:
		if slot.stored_item == item:
			total += slot.count
	return total

func find_slots(item: InventoryItem) -> Array[int]:
	var result: Array[int] = []
	for i in Data.slots.size():
		if Data.slots[i].stored_item == item:
			result.append(i)
	return result

func add_item(item: InventoryItem, amount: int) -> int:
	if amount <= 0:
		return 0

	var remaining: int = amount

	for i in Data.slots.size():
		if remaining <= 0:
			break
		var slot := Data.slots[i]
		if slot.stored_item == item and not slot.is_full():
			slot.insert(item, remaining) #FIXME insert no longer returns int!!!
			#var inserted: int = slot.insert(item, remaining)
			#if inserted > 0:
				#remaining -= inserted
				#slot_changed.emit(i)

	for i in Data.slots.size():
		if remaining <= 0:
			break
		var slot := Data.slots[i]
		if slot.is_empty():
			slot.insert(item, remaining)
			#var inserted := slot.insert(item, remaining)
			#if inserted > 0:
				#remaining -= inserted
				#slot_changed.emit(i)

	var added := amount - remaining
	if added > 0:
		item_added.emit(item, added)
		inventory_changed.emit()

	return added

func remove_item(item: InventoryItem, amount: int) -> int:
	if amount <= 0:
		return 0

	var remaining: int = amount

	for i in Data.slots.size():
		if remaining <= 0:
			break
		var slot := Data.slots[i]
		if slot.stored_item == item:
			var removed: int = min(slot.count, remaining)
			slot.remove(removed)
			remaining -= removed
			#slot_changed.emit(i)

	var removed_total := amount - remaining
	if removed_total > 0:
		item_removed.emit(item, removed_total)
		inventory_changed.emit()

	return removed_total

func swap_slots(a: int, b: int) -> void:
	var tmp := Data.slots[a]
	Data.slots[a] = Data.slots[b]
	Data.slots[b] = tmp
	slot_changed.emit(a)
	slot_changed.emit(b)
	inventory_changed.emit()

func move_slot(from: int, to: int) -> void:
	if from == to:
		return

	var src := Data.slots[from]
	var dst := Data.slots[to]

	if dst.can_merge(src):
		dst.merge_from(src)
	else:
		Data.slots[from] = dst
		Data.slots[to] = src

	slot_changed.emit(from)
	slot_changed.emit(to)
	inventory_changed.emit()

func clear() -> void:
	for i in Data.slots.size():
		Data.slots[i].clear()
		slot_changed.emit(i)
	inventory_changed.emit()

func is_full() -> bool:
	for slot in Data.slots:
		if slot.is_empty() or not slot.is_full():
			return false
	return true

func is_valid() -> bool:
	return Data != null and Data.slots.size() > 0
