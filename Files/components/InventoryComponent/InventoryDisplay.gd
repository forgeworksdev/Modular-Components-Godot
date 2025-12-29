class_name InventoryDisplay extends ItemList

@export var inventory: InventoryComponent = null

@export var empty_icon: Texture2D

func _ready() -> void:
	if inventory == null:
		push_error("InventoryDisplay: inventory is null")
		return

	select_mode = ItemList.SELECT_SINGLE
	fixed_icon_size = Vector2i(64, 64)
	icon_mode = ItemList.ICON_MODE_TOP
	same_column_width = true
	max_columns = 5
	allow_reselect = true
	focus_mode = FocusMode.FOCUS_NONE

	_connect_signals()
	_rebuild()

func _rebuild() -> void:
	clear()

	for i in inventory.slot_count():
		_add_slot(i)

func _connect_signals() -> void:
	inventory.inventory_changed.connect(_on_inventory_changed)
	inventory.slot_changed.connect(_on_slot_changed)

func _add_slot(index: int) -> void:
	var slot := inventory.get_slot(index)

	if slot.is_empty():
		add_item("--", empty_icon)
		set_item_disabled(index, true)
		return

	var label := "%s x%d" % [slot.stored_item.name, slot.count]
	add_item(label, slot.stored_item.texture)
	set_item_disabled(index, false)

func _refresh_slot(index: int) -> void:
	if index < 0 or index >= item_count:
		return

	var slot := inventory.get_slot(index)

	if slot.is_empty():
		set_item_text(index, "—")
		set_item_icon(index, null)
		set_item_disabled(index, true)
		return

	set_item_text(index, "%s x%d" % [slot.stored_item.name, slot.count])
	set_item_icon(index, slot.stored_item.texture)
	set_item_disabled(index, false)

func _on_inventory_changed() -> void:
	if item_count != inventory.slot_count():
		_rebuild()

func _on_slot_changed(index: int) -> void:
	_refresh_slot(index)
