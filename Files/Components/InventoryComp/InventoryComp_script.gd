## A modular component that manages a collection of [InventoryItem] via an [InventoryDatabase].
class_name InventoryComponent extends Control

## Inventory database.
@export var InventoryData: InventoryDatabase

func print_items() -> void:
	for slot: InventorySlot in InventoryData.slots:
		print(slot.stored_item.itemID) if slot.stored_item else print("No item found! (%s)" % self.name)

func add_item(item: InventoryItem, amount: int = 1) -> void:
	InventoryData.slots.append(item)

func remove_item(id: int) -> void:
	for slot: InventorySlot in InventoryData.slots:
		if slot.stored_item.id == id:
			InventoryData.slot.erase(id)

func find_item_by_name(item_name: String) -> Array[InventoryItem]:
	var result: Array[InventoryItem]
	for slot in InventoryData.slots:
		if slot.stored_item.name == item_name:
			result.append(InventoryItem)
	return result

func reset_inventory_database() -> void:
	var old_slot_count: int = InventoryData.slot_count
	InventoryData = InventoryDatabase.new()
	InventoryData.slot_count = old_slot_count


func _ready() -> void:
	if self.InventoryData == null:
		push_warning("No inventory database found on %s! Generating new one!" % self.name)
		InventoryData = InventoryDatabase.new()
		InventoryData.slot_count = 20
	print_items()
