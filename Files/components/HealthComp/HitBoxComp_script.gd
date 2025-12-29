## Hitbox.gd
class_name HitboxComponent extends Area2D

@export var enabled: bool = true
## Base damage of this hitbox.
@export var damage: int = 10
## Owner of the hitbox, usually the character performing the attack.
@export var owner_node: Node

func _ready() -> void:
	add_to_group("hitbox")
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
