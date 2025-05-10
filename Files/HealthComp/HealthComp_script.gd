extends Node

signal damaged
signal death
signal healed

@export var amount: int = 100
@export var max_amount: int = 100
@export var max_damage: int = 100
@export var uses_hearts: bool = false
@export var has_i_frames: bool = false
@export var i_time: float
@export var go_scn_path: String
@export var hearts: Array[NodePath] = [
	]

var can_damage: bool = true
var timer: Timer

func _ready() -> void:
	amount = clamp(amount, 0, max_amount)
	create_timer()

func heal(heal_amount: int):
	amount += heal_amount if heal_amount < max_amount else max_amount
	healed.emit()

func create_timer():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = i_time
	timer.timeout.connect(_on_timer_timeout)

func damage(dmg: int):
	if (!has_i_frames or can_damage):
		if dmg > max_damage:
			dmg = max_damage
		amount -= dmg
		can_damage = false
		damaged.emit()
		timer.start()
		if amount <= 0:
			amount = 0
			death.emit()
			if not go_scn_path.is_empty():
				get_tree().change_scene_to_file(go_scn_path)
		if uses_hearts:
			update_hearts()

func _on_timer_timeout():
	can_damage = true

func update_hearts():
	pass
	#for i in range(3):
		#if i < amount:
			#get_node(hearts[i]).texture = load("res://resources/sprites/heart_03.png")
		#else:
			#get_node(hearts[i]).texture = load("res://resources/sprites/heart_02.png")
	#if amount == 1:
		#get_node(hearts[0]).material.set_shader_parameter("is_shaking", true)
	#else:
		#get_node(hearts[0]).material.set_shader_parameter("is_shaking", false)
