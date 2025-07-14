## A modular health component supporting healing, damage, death events, invincibility frames, and heart-based UI.
@tool
class_name HealthComponent extends Node

## Emitted when this component takes damage.
signal damaged

## Emitted when health reaches 0.
signal death

## Emitted when this component is healed.
signal healed

var _max_amount: int = 100
## Maximum health this component can have.
@export var max_amount: int = 100:
	set(value):
		_max_amount = max(value, 1)
		if amount > _max_amount:
			amount = _max_amount
	get:
		return _max_amount

var _amount: int = 100
## Current health value. Clamped between 0 and max_amount.
@export var amount: int:
	set(value):
		_amount = clamp(value, 0, max_amount)
	get:
		return _amount

var _max_damage: int = 100
## Maximum allowed damage per hit. Any damage higher than this will be clamped.
@export var max_damage: int = 100:
	set(value):
		_max_damage = max(value, 0)
	get:
		return _max_damage


## Enables visual heart-based UI updates.
@export var uses_hearts: bool = false

## Enables invincibility frames after taking damage.
@export var has_i_frames: bool = false

## Duration of invincibility (in seconds) if has_i_frames is enabled.
@export var i_time: float = 0.5

## Optional scene path to change to upon death.
@export var gameover_scene: PackedScene

## NodePaths to heart UI elements (TextureRects or Sprites).
@export var hearts: Array[NodePath] = []

## Internal flag to control damage timing when invincibility is active.
var can_damage: bool = true

## Internal timer used for invincibility logic.
var timer: Timer

func _ready() -> void:
	amount = clamp(amount, 0, max_amount)
	create_timer()
	_amount = clamp(_amount, 0, max_amount)

func heal(heal_amount: int) -> void:
	amount = min(amount + heal_amount, max_amount)
	healed.emit()
	if uses_hearts:
		update_hearts()

func create_timer() -> void:
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = i_time
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func damage(dmg: int) -> void:
	if not has_i_frames or can_damage:
		dmg = min(dmg, max_damage)
		amount = max(amount - dmg, 0)
		can_damage = false
		damaged.emit()
		if has_i_frames:
			timer.start()
		if amount == 0:
			death.emit()
			if not gameover_scene == null:
				get_tree().change_scene_to_packed(gameover_scene)
		if uses_hearts:
			update_hearts()

func _on_timer_timeout() -> void:
	can_damage = true

func update_hearts() -> void:
	for i in hearts.size():
		var heart_node := get_node_or_null(hearts[i])
		if heart_node == null:
			continue
		if i < amount:
			heart_node.texture = load("res://resources/sprites/heart_03.png")
		else:
			heart_node.texture = load("res://resources/sprites/heart_02.png")
	if amount == 1:
		var first_heart := get_node_or_null(hearts[0])
		if first_heart and first_heart.material:
			first_heart.material.set_shader_parameter("is_shaking", true)
	else:
		var first_heart := get_node_or_null(hearts[0])
		if first_heart and first_heart.material:
			first_heart.material.set_shader_parameter("is_shaking", false)
