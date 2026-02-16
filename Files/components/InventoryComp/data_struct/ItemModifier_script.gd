## Modifier for item attributes. For systems like enchanting
class_name ItemModifier extends Resource

## Attribute this modifier affects (ex: "damage").
@export var target_attribute: StringName

## Type of modification.
@export_enum("add", "multiply", "override") var type: String = "add"

## Modifier value.
@export var value: float = 0.0

#func apply(current: float) -> float:
	#match operation:
		#"add":
			#return current + value
		#"multiply":
			#return current * value
		#"override":
			#return value
#
	#return current
