## Base class for inventory items
class_name InventoryItem extends Resource

## Name of the item.
@export var name: String
## Item decsription.
@export_multiline var description: String = ""
## Item category, for sorting.
@export_enum("Tool", "Consumable", "Equipable", "Material", "Currency") var category: String
## Item texture
@export var texture: Texture2D
## Item ID.
var itemID: int = IDGen.generate_id()
