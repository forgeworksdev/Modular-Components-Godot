class_name InventoryItem extends Resource

@export var name: StringName = &"Icon"

## @deprecated: Unused
@export_file("*.png", "*.jpeg", "*.pxo") var texture_path: String

@export var _texture: CompressedTexture2D = preload("res://Icon.png")

@export_enum(
	"metais alcalinos",
	"metais alcalinoterrosos",
	"outros metais",
	"metais de transição",
	"lantanídeos",
	"actinídeos",
	"semimetais",
	"não metais",
	"halogênios",
	"gases nobres",
	"desconhecidas"
) var category: String

@export_multiline var description: String = "Your project's Icon.png"

@export var stack_size: int = 24

## @deprecated: Items rely on Godot UUIDs
## A numeric identifier for this item.
@export var id: int

@export var attributes: Dictionary[String, Variant]
