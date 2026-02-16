@icon("uid://efg3jqbh3361")
class_name GameController extends Node

var _transition_in_progress: bool = false

enum WorldTypes {
	WORLD3D = 1 << 0, # 1
	WORLD2D = 1 << 1, # 2
	GUI = 1 << 2, # 4
	NODE = 1 << 3 # 8
}

var _active_scenes: Dictionary[WorldTypes, Array] = {
	WorldTypes.WORLD3D: [],
	WorldTypes.WORLD2D: [],
	WorldTypes.GUI: [],
	WorldTypes.NODE: []
}

@export var world_3d_root: Node3D
@export var world_2d_root: Node2D
@export var gui_root: CanvasLayer
@export var node_root: Node

@export var vfx_root: CanvasLayer

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	#Global.game_controller = self
	#Global.is_managed_instance = true
	for world in WorldTypes.values():
		var parent := _get_parent_for_type(world)
		if parent == null:
			continue

		for child in parent.get_children():
			_active_scenes[world].append(child)

func change_scene_safe(scene: PackedScene, world_type: WorldTypes, clear_mask: int = 0, transition: bool = true, extra: Array[Callable] = []) -> bool:
	if _transition_in_progress:
		return false

	_transition_in_progress = true

	if transition:
		var vfx := vfx_root.get_node("SceneTransitionVFX")
		await vfx.transition(func () -> void:
			clear_worlds(clear_mask)
			add_scene(scene, world_type)
			for cb in extra:
				if cb.is_valid():
					cb.call()
		)
	else:
		clear_worlds(clear_mask)
		add_scene(scene, world_type)
		for cb in extra:
			if cb.is_valid():
				cb.call()

	_transition_in_progress = false
	return true

func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused

func add_scene(scene: PackedScene, world_type: WorldTypes) -> Node:
	if !scene:
		push_error("GameController: Invalid scene!")
		return

	var instance := scene.instantiate()
	var parent := _get_parent_for_type(world_type)

	if parent == null:
		push_error("GameController: Invalid parent for world type %s" % world_type)
		return null

	parent.add_child(instance)
	_active_scenes[world_type].append(instance)
	return instance

func remove_scene(scene: Node, free: bool = true) -> void:
	for world_type: WorldTypes in _active_scenes.keys():
		if scene in _active_scenes[world_type]:
			_active_scenes[world_type].erase(scene)
			if free:
				scene.queue_free()
			else:
				scene.get_parent().remove_child(scene)
			return

func get_scenes(world_type: WorldTypes) -> Array:
	return _active_scenes[world_type].duplicate()

func hide_world(world_type: WorldTypes) -> void:
	for scene in _active_scenes[world_type]:
		if "visible" in scene:
			scene.visible = false

func show_world(world_type: WorldTypes) -> void:
	for scene in _active_scenes[world_type]:
		if "visible" in scene:
			scene.visible = true

func clear_worlds(mask: int) -> void:
	for world in WorldTypes.values():
		if mask & world:
			clear_world(world)

func clear_world(world_type: WorldTypes) -> void:
	for scene in _active_scenes[world_type]:
		scene.queue_free()
	_active_scenes[world_type].clear()

func _get_parent_for_type(world_type: WorldTypes) -> Node:
	match world_type:
		WorldTypes.WORLD3D:
			return world_3d_root
		WorldTypes.WORLD2D:
			return world_2d_root
		WorldTypes.GUI:
			return gui_root
		WorldTypes.NODE:
			return node_root
		_:
			return null

func quit_game(exit_code: int) -> void:
	get_tree().quit(exit_code)
