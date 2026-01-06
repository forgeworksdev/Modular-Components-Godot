class_name GameController extends Node

@export var world_3d: Node3D
@export var world_2d: Node2D
@export var gui: Control


var current_3d_scene: Node3D = null
var current_2d_scene: Node2D = null
var current_gui_scene: Control = null

func _ready() -> void:
	if not world_3d:
		world_3d = Node3D.new()
		world_3d.name = "World3D"

func change_gui_scene(new_scene_path: String, delete_current: bool = true, keep_running: bool = false) -> void:
	if current_gui_scene != null:
		if delete_current:
			current_gui_scene.queue_free()
		elif keep_running:
			current_gui_scene.hide()
		else:
			gui.remove_child(current_gui_scene)
	var new =load(new_scene_path).instantiate()
	gui.add_child(new)
	current_gui_scene = new

func change_3d_scene(new_scene_path: String, delete_current: bool = true, keep_running: bool = false) -> void:
	if current_3d_scene != null:
		if delete_current:
			current_3d_scene.queue_free()
		elif keep_running:
			current_3d_scene.hide()
		else:
			world_3d.remove_child(current_3d_scene)
	var new =load(new_scene_path).instantiate()
	world_3d.add_child(new)
	current_3d_scene = new

func change_2d_scene(new_scene_path: String, delete_current: bool = true, keep_running: bool = false) -> void:
	if current_2d_scene != null:
		if delete_current:
			current_2d_scene.queue_free()
		elif keep_running:
			current_2d_scene.hide()
		else:
			world_2d.remove_child(current_2d_scene)
	var new = load(new_scene_path).instantiate()
	world_2d.add_child(new)
	current_2d_scene = new
