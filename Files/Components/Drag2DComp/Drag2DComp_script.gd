class_name Drag2DComponent extends Node

#Exported vars
##Which object will be made draggable. If not specified, will assume target = parent.
@export var target: CanvasItem
##Defines if dragging is possible.
@export var can_drag: bool
@export var center_drag: bool
@export var drag_offset: Vector2
@export var grid_size: Vector2
##Area in which dragging will be detected.
@export var interactable_area: Area2D

#Vars
var is_dragging: bool = false

var drag_target: CanvasItem

var target_size: Vector2 = Vector2.ZERO

func _ready() -> void:
	if target != null:
		drag_target = target
	else:
		drag_target = get_parent() if get_parent() is CanvasItem else null
	if drag_target == null:
		print("Error: Parent is not/does not extend Node2D (does not have a position value)")
	if interactable_area:
		interactable_area.connect("input_event", handle_interactions)
		#interactable_area.connect("mouse_exited", handle_mouse_exited)
		#interactable_area.connect("input_event", handle_interactions)
	else:
		print("Error: No interactable area! Generating one based on parent dimentions!")
		generate_interactable_area().connect("input_event", handle_interactions)

func generate_interactable_area() -> Area2D:
	var area: Area2D = Area2D.new()
	var collision: CollisionShape2D = CollisionShape2D.new()
	var shape: RectangleShape2D = RectangleShape2D.new()
	collision.shape = shape

	if drag_target is not Sprite2D:
		target_size = drag_target.size
		collision.position = get_parent().size/2
	else:
		target_size = Vector2(drag_target.texture.get_width(), drag_target.texture.get_height())
		collision.position = target_size/2
		drag_target.centered = false
	shape.size = target_size
	area.add_child(collision)
	get_parent().add_child.call_deferred(area)
	print("Success!")
	return area

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		is_dragging = false
	var mouse_pos: Vector2
	mouse_pos = get_parent().get_global_mouse_position()
	if !is_dragging or drag_target == null:
		return
	#elif !snap_to_grid:
		#drag_target.position = mouse_pos + (drag_offset * 1)
	else:

		drag_target.position = mouse_pos.snapped(grid_size) + drag_offset if !center_drag else mouse_pos.snapped(grid_size) - target_size/2 * drag_target.scale + drag_offset

func handle_interactions(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = event.pressed

func handle_mouse_exited() -> void:
	is_dragging = false
