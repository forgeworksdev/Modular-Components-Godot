class_name CharacterController2DComponent extends CharacterBody2D

@onready var camera: Camera2D = $Camera2D
#@onready var interact_ray: RayCast2D = $InteractRayCast2D
@export var standing_collision: CollisionShape2D
@export var crouching_collision: CollisionShape2D

@export_group("Flags")
@export var can_move: bool = true
@export var can_jump: bool = true
@export var has_gravity: bool = true
@export var can_crouch: bool = true
@export var has_movement_vfx: bool = true
@export var can_interact: bool = true

@export_group("Speed Vars")
@export var WALK_SPEED: float = 130.0
@export var SPRINT_SPEED: float = 200.0
@export var CROUCH_SPEED: float = 75.0
@export var JUMP_FORCE: float = -240.0
@export var ACCEL: float = 12.0
@export var AIR_ACCEL: float = 5.0

var speed: float = 0.0
var is_crouching: bool = false
var is_sprinting: bool = false

const BOB_FREQ: float = 6.0
const BOB_AMP: float = 1.0
var bob_time: float = 0.0

@export_group("Camera Options")
@export var zoom_amount: float = 1.0
@export var zoom_increment: float = 0.15
@export_range(0.1, 10.0, 0.01) var mouse_sensitivity: float = 1.0

signal can_interact_signal
signal can_pickup_signal

func _ready() -> void:
	camera.zoom = Vector2(zoom_amount, zoom_amount)


func _unhandled_input(event: InputEvent) -> void:
	# 2D cannot rotate vertically/horizontally like 3D; omitted.
	pass


func _handle_gravity(delta: float) -> void:
	if has_gravity and not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta


func _handle_jump() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE


func _crouch(delta: float) -> void:
	if Input.is_action_pressed("crouch"):
		is_crouching = true
		standing_collision.disabled = true
		crouching_collision.disabled = false
	else:
		is_crouching = false
		standing_collision.disabled = false
		crouching_collision.disabled = true


func _handle_movement(delta: float) -> void:
	is_sprinting = Input.is_action_pressed("sprint")

	if is_crouching:
		speed = CROUCH_SPEED
	elif is_sprinting:
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	var target_vel := input_dir * speed

	if is_on_floor():
		velocity = velocity.lerp(Vector2(target_vel.x, target_vel.y), delta * ACCEL)
	else:
		velocity = velocity.lerp(Vector2(target_vel.x, target_vel.y), delta * AIR_ACCEL)

#
#func _process_movement_vfx(delta: float) -> void:
	#if not has_movement_vfx:
		#return
#
	#var floor_factor: float = float(is_on_floor())
	#bob_time += delta * velocity.length() * floor_factor
#
	#if velocity.length() > 5.0 and is_on_floor():
		#camera.offset = Vector2(
			#sin(bob_time * BOB_FREQ) * BOB_AMP,
			#cos(bob_time * BOB_FREQ * 0.5) * BOB_AMP
		#)
	#else:
		#camera.offset = Vector2.ZERO
#
	#var speed_ratio: float = clamp(velocity.length() / SPRINT_SPEED, 0.0, 1.0)
	#var target_zoom := zoom_amount + (zoom_increment * speed_ratio)
	#camera.zoom = camera.zoom.lerp(Vector2(target_zoom, target_zoom), delta * 8.0)


func _physics_process(delta: float) -> void:
	if has_gravity:
		_handle_gravity(delta)
	if can_jump:
		_handle_jump()
	if can_crouch:
		_crouch(delta)
	if can_move:
		_handle_movement(delta)

	_process_movement_vfx(delta)
	move_and_slide()
