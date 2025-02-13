class_name Wire_cb
extends Line2D

#Exports
@export var snap_to_grid: bool
@export var grid_size: Vector2

#Vars
var can_drag: bool = false

const MAX_POINTS: int = 2

var _voltage: float = 0.0
var voltage: float:
	set(new_voltage):
		_voltage = new_voltage
		sync_values()
	get:
		return _voltage

var _current: float = 0.0
var current: float#:
	#set(new_current):
		#_current = new_current
		#sync_values()
	#get:
		#return _current

var is_connected_to_PSU_minus: bool

var connected_wires: Array = []

var wire_start_area :=  Area2D.new()
var start_area_collision := CollisionShape2D.new()

var wire_middle_area :=  Area2D.new()
var middle_area_collision := CollisionShape2D.new()

var wire_end_area :=  Area2D.new()
var end_area_collision := CollisionShape2D.new()

func _init() -> void:
	self.begin_cap_mode = Line2D.LINE_CAP_BOX
	self.end_cap_mode = Line2D.LINE_CAP_BOX
	self.joint_mode = Line2D.LINE_JOINT_ROUND
	self.width = 4
	self.add_point(Vector2.ZERO)
	self.add_point(Vector2.ZERO)

func _ready() -> void:
	print(str(self.name) + "was added into the scene tree! (Wire_cb)")

	add_child(wire_start_area)
	wire_start_area.add_child(start_area_collision)
	start_area_collision.shape = CircleShape2D.new()
	wire_start_area.connect("area_entered", wire_start_area_entered)

	add_child(wire_middle_area)
	wire_middle_area.add_child(middle_area_collision)
	middle_area_collision.shape = SegmentShape2D.new()
	wire_middle_area.connect("area_entered", wire_middle_area_entered)

	add_child(wire_end_area)
	wire_end_area.add_child(end_area_collision)
	end_area_collision.shape = CircleShape2D.new()
	wire_end_area.connect("area_entered", wire_end_area_entered)

	await get_tree().create_timer(.2).timeout
	can_drag = true

func _process(delta: float) -> void:
	update_collisionshape_positions()
	#sync_values()

	#if not can_drag :
		#return
	if can_drag:
		var local_mouse_pos = to_local(get_global_mouse_position().snapped(grid_size))
		set_point_position(get_point_count() - 1, local_mouse_pos)
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and get_point_count():
			set_point_position(get_point_count() -1, local_mouse_pos)
			can_drag = false

func update_collisionshape_positions():
	if points.size() >= 2:
		wire_start_area.global_position = to_global(get_point_position(0))
		wire_end_area.global_position = to_global(get_point_position(get_point_count() - 1))
		middle_area_collision.shape.a = (get_point_position(0))
		middle_area_collision.shape.b = (get_point_position(get_point_count() - 1))

func get_voltage():
	#print(str(voltage))
	return voltage

func get_current():
	#print(str(current))
	return current

func set_voltage(new_voltage: float = 0):
	if voltage != new_voltage:
		voltage = new_voltage

func set_current(new_current: float = 0):
	if current != new_current:
		current = new_current

func sync_values():
	for wire in connected_wires:
		wire.set_voltage(self.voltage)
		print("Sync-ed wire voltage")

func are_siblings(node_a, node_b) -> bool:
	#print(str(node_a.get_parent()))
	#print(str(node_b.get_parent()))
	print(str(node_a.get_parent() == node_b.get_parent()))
	return node_a.get_parent() == node_b.get_parent()

func wire_start_area_entered(area: Area2D):
	if !can_drag:
		if !are_siblings(area, wire_start_area):
			var other_node := area.get_parent()
			if other_node not in connected_wires:
				connected_wires.append(other_node)
				print("Connected a wire")

func wire_middle_area_entered(area: Area2D):
	pass

func wire_end_area_entered(area: Area2D):
	if !can_drag:
		if !are_siblings(area, wire_end_area):
			#and area.get_child(0).shape == CircleShape2D:
			var other_node := area.get_parent()
			if other_node not in connected_wires:
				connected_wires.append(other_node)
				print("Connected a wire")
