extends Node

#Exports
@export var target: Node2D ##Which object will be made draggable. If not specified, will assume target as parent
@export var can_drag: bool
@export var snap_to_grid: bool
@export var drag_offset: Vector2
@export var grid_size: Vector2
@export var interactable_area: Area2D
@export var scale_factor: float
#Vars
var is_dragging: bool = false

func _ready() -> void:
	if interactable_area:
		interactable_area.connect("input_event", handle_interactions)
		#interactable_area.connect("mouse_exited", handle_mouse_exited)
		#interactable_area.connect("input_event", handle_interactions)
	else:
		print("Error: No interactable area!")

func _process(delta: float) -> void:
	var mouse_pos
	if scale_factor > 0:
		mouse_pos = get_parent().get_global_mouse_position() / scale_factor
	if scale_factor == 0:
		mouse_pos = get_parent().get_global_mouse_position() / 1
	var drag_target: Node2D

	if target != null:
		drag_target = target
	else:
		drag_target = get_parent()

	if !is_dragging:
		return
	elif drag_target is not Node2D:
		print("Error: Parent is not/does not extend Node2D (does not have a position value)")
		return
	elif !snap_to_grid:
		drag_target.position = mouse_pos + (drag_offset * 1)
	else:
		drag_target.position = mouse_pos.snapped(grid_size) + (drag_offset * 1)

func _input(event: InputEvent) -> void:
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		is_dragging = false

func handle_interactions(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = event.pressed

func handle_mouse_exited():
	is_dragging = false
