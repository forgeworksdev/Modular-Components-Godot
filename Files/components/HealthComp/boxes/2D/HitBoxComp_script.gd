## Hitbox.gd
class_name HitboxComponent extends Area2D

@export var enabled: bool = true:
	set(value):
		enabled = value
		if is_inside_tree():
			_update_enabled()
	get:
		return enabled
## Base damage of this hitbox.
@export var damage: int = 10
## Owner of the hitbox, usually the character performing the attack.
@export var owner_node: Node

func _ready() -> void:
	add_to_group("hitbox")


func _update_enabled() -> void:
	monitoring = enabled
	monitorable = enabled
