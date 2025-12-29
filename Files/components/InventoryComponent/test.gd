class_name InventoryTest
extends Node

@export var inventory_size: int = 8
@export var test_item_a: InventoryItem
@export var test_item_b: InventoryItem

@export var inventory: InventoryComponent

func _ready() -> void:
	_setup_inventory()
	_connect_signals()
	_run_tests()


func _setup_inventory() -> void:
	var data := InventoryData.new()
	data.slots = []

	for i in inventory_size:
		data.slots.append(InventorySlot.new())

	inventory.Data = data



func _connect_signals() -> void:
	inventory.inventory_changed.connect(_on_inventory_changed)
	inventory.slot_changed.connect(_on_slot_changed)
	inventory.item_added.connect(_on_item_added)
	inventory.item_removed.connect(_on_item_removed)


func _run_tests():
	print("\n--- INVENTORY TEST START ---")

	_test_add_items()
	_test_stack_overflow()
	_test_remove_items()
	_test_multiple_items()
	_test_slot_move()
	#_test_clear()

	print("--- INVENTORY TEST END ---\n")


func _test_add_items() -> void:
	print("\n[TEST] Add items")
	var added := inventory.add_item(test_item_a, 10)
	_assert(added == 10, "Add 10 items")
	_dump()


func _test_stack_overflow() -> void:
	print("\n[TEST] Stack overflow")
	var added := inventory.add_item(test_item_a, test_item_a.stack_size * 2)
	_assert(added > 0, "Overflow distributes across slots")
	_dump()


func _test_remove_items() -> void:
	print("\n[TEST] Remove items")
	var removed := inventory.remove_item(test_item_a, 5)
	_assert(removed == 5, "Remove 5 items")
	_dump()


func _test_multiple_items() -> void:
	print("\n[TEST] Multiple item types")
	inventory.add_item(test_item_b, 7)
	_dump()


func _test_slot_move() -> void:
	print("\n[TEST] Slot move / merge")
	inventory.move_slot(0, 1)
	_dump()


func _test_clear() -> void:
	print("\n[TEST] Clear inventory")
	inventory.clear()
	_dump()


func _dump() -> void:
	for i in inventory.Data.slots.size():
		var slot := inventory.Data.slots[i]
		if slot.is_empty():
			print("Slot ", i, ": EMPTY")
		else:
			print(
				"Slot ", i,
				": ", slot.stored_item.name,
				" x", slot.count
			)


func _assert(condition: bool, label: String) -> void:
	if condition:
		print("[OK] ", label)
	else:
		push_error("[FAIL] " + label)


# --- SIGNAL DEBUG ---

func _on_inventory_changed() -> void:
	print("Signal: inventory_changed")

func _on_slot_changed(index: int) -> void:
	print("Signal: slot_changed -> ", index)

func _on_item_added(item: InventoryItem, amount: int) -> void:
	print("Signal: item_added -> ", item.name, " x", amount)

func _on_item_removed(item: InventoryItem, amount: int) -> void:
	print("Signal: item_removed -> ", item.name, " x", amount)
