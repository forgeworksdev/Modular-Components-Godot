## Healbox.gd
class_name HealboxComponent extends Area2D

@export var enabled: bool = true
## Base heal amount of this box.
@export var heal_amount: int = 10
## Owner of the healbox, usually the character performing the heal.
@export var owner_node: Node

func _ready() -> void:
	add_to_group("healbox")
	if enabled:
		enable()
	else:
		disable()

func enable() -> void:
	monitoring = true
	monitorable = true

func disable() -> void:
	monitoring = false
	monitorable = false
