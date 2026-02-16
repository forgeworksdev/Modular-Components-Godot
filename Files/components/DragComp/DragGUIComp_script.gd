class_name DragGUIComponent extends Node

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

var target_size: Vector2 = Vector2.ZERO

signal started_dragging_signal(pos: Vector2)
signal position_updated_signal(pos: Vector2)
signal stopped_dragging_signal(pos: Vector2)

func _ready() -> void:
	if target == null and get_parent() is CanvasItem:
		target = get_parent()
	elif target == null:
		push_error("Parent is not a CanvasItem, and target was not manually assigned.")
		return

	if target is Sprite2D:
		var sprite := target as Sprite2D
		if sprite.texture:
			target_size = Vector2(sprite.texture.get_width(), sprite.texture.get_height()) * sprite.scale
			sprite.centered = false
		else:
			push_error("Sprite2D target has no texture.")
			target_size = Vector2.ZERO
	elif "size" in target:
		target_size = target.size
	else:
		push_error("Target does not have a 'size' property.")
		target_size = Vector2.ZERO

	if interactable_area:
		interactable_area.connect("input_event", handle_interactions)
	else:
		push_warning("Warning: No interactable_area assigned.")
		#interactable_area = generate_interactable_area()
		#interactable_area.connect("input_event", handle_interactions)

func generate_interactable_area() -> Area2D:
	var area := Area2D.new()
	area.name = "GeneratedDragArea"
	area.position = Vector2.ZERO

	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = target_size
	collision.shape = shape
	collision.position = target_size * 0.5

	area.add_child(collision)
	get_parent().add_child.call_deferred(area)

	push_warning("Drag2DComponent: Interactable area generated with size: ", target_size)
	print("Drag2DComponent: Interactable area generated with size: ", target_size)
	return area

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and !event.pressed and is_dragging:
		is_dragging = false
		print("Drag2DComponent: Stopped dragging %s " % target.name)
		stopped_dragging_signal.emit(target.position)
	var mouse_pos: Vector2
	mouse_pos = get_parent().get_global_mouse_position()
	if !is_dragging or target == null:
		return
	else:
		target.position = mouse_pos.snapped(grid_size) \
		+ drag_offset if !center_drag else mouse_pos.snapped(grid_size) \
		- target_size/2 * target.scale + drag_offset
		position_updated_signal.emit(target.position)

func handle_interactions(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		is_dragging = true
		print("Started dragging %s (Drag2DComponent)" % target.name)
		started_dragging_signal.emit(target.position)

func handle_mouse_exited() -> void:
	is_dragging = false
	print("Stopped dragging %s (Drag2DComponent)" % target.name)
