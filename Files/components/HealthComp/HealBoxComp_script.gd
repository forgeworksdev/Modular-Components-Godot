## Healbox.gd
class_name HealboxComponent extends Area2D

@export var enabled: bool = true:
	set(value):
		enabled = value
		if is_inside_tree():
			_update_enabled()
	get:
		return enabled
## Base heal amount of this box.
@export var heal_amount: int = 10
## Owner of the healbox, usually the character performing the heal.
@export var owner_node: Node

func _ready() -> void:
	add_to_group("healbox")

func _update_enabled() -> void:
	monitoring = enabled
	monitorable = enabled
