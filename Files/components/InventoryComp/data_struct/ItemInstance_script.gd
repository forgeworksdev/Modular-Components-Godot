class_name ItemInstance extends Resource

@export var item: InventoryItem

@export_subgroup("Instance properties")

@export var display_name: String
@export var durability: int
@export var modifiers: Array[ItemModifier]

@export var metadata: Dictionary[String, Variant]


#FIXME EXPERIMENTAL
func get_attribute(attr: StringName) -> float:
	var base := float(item.attributes.get(attr, 0))

	var add_total := 0.0
	var mul_total := 1.0
	var override_value = null

	for m in modifiers:
		if m.target_attribute != attr:
			continue

		match m.type:
			"add":
				add_total += m.value
			"multiply":
				mul_total *= m.value
			"override":
				override_value = m.value

	var result := (base + add_total) * mul_total

	if override_value != null:
		result = override_value

	return result
