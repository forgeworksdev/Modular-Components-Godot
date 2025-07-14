## Holds an [InventoryItem] and stores quantity.
class_name InventorySlot extends Resource

const MAX_ITEM_STACK: int = 128
@export var stored_item: InventoryItem
@export_range(1, MAX_ITEM_STACK) var amount: int
