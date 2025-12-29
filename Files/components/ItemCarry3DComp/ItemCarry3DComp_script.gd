class_name ItemCarry3DComponent extends Node

@export_subgroup("Component")
@export var enable: bool = false
@export var action_name: String
@export var group_name: String
@export var raycast: RayCast3D
@export var hand: Node3D
@export var impulse_strength: int
@export var PICKUP_LAYER: int = 2
@export var DEFAULT_LAYER: int = 2
var is_holding_object: bool = false
var held_object: Node = null

func _handle_holding_objects() -> void:
	if Input.is_action_just_pressed(action_name) and is_holding_object:
		held_object.collision_layer = 1
		held_object.freeze = false
		held_object.apply_central_impulse(Vector3(0, impulse_strength, 0))
		held_object = null
		is_holding_object = false
		return

	if held_object:
		held_object.global_position = hand.global_position
		held_object.global_rotation = hand.global_rotation

	if Input.is_action_just_pressed(action_name) and raycast.is_colliding() and not is_holding_object:
		var object = raycast.get_collider()
		if object.is_in_group(group_name):
			held_object = object
			held_object.collision_layer = 2
			held_object.freeze = true
			is_holding_object = true

func _physics_process(_delta: float) -> void:
	if enable:
		_handle_holding_objects()
