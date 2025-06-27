class_name CharacterControler3DComponent extends Node
#
#@export_category("Toggles")
#@export var can_walk: bool = true
#@export var can_crouch: bool = true
#@export var can_jump: bool = true
#@export var can_look: bool = true
#@export var has_gravity: bool = true
#
#@export_category("Properties")
#var current_speed: float
#
#@export_category("Variables")
#@export var crouch_speed: float = 3.0
#@export var sprint_speed: float = 10.0
#@export var walk_speed: float = 6.0
#@export var deceleration: float = 15.0
#
#@export var crouch_height: float = 0.9
#@export var STAND_HEIGHT: float = 1.6
#
#const MOUSE_SENSITIVITY: float = 0.4
#const LERP_SPEED: float = 5.0
#
#var direction: Vector3 = Vector3.ZERO
#
## Jump parameters
#var jump_velocity: float
#var jump_gravity: float
#var fall_gravity: float
#
#var can_interact: bool = false
#
#const JUMP_HEIGHT: float = 2.0
#const JUMP_PEAK_TIME: float = 0.5
#const JUMP_FALL_TIME: float = 0.5
#
#signal can_interact_signal
#signal cant_interact_signal
#
#func _ready() -> void:
	#jump_velocity = (2.0 * JUMP_HEIGHT) / JUMP_PEAK_TIME
	#jump_gravity = (2.0 * JUMP_HEIGHT) / pow(JUMP_PEAK_TIME, 2)
	#fall_gravity = (2.0 * JUMP_HEIGHT) / pow(JUMP_FALL_TIME, 2)
	#ray_cast_3d.enabled = true
#
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and can_look:
		#rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		#head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSITIVITY))
		#head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
#
#func _physics_process(delta: float) -> void:
	#handle_crouch_state(delta)
	#apply_gravity(delta)
	#handle_jump()
	#process_movement(delta)
	#move_and_slide()
#
#func handle_crouch_state(delta: float) -> void:
	#if Input.is_action_pressed("crouch") and can_crouch:
		#current_speed = CROUCH_SPEED
		#head.position.y = move_toward(head.position.y, CROUCH_HEIGHT, delta * LERP_SPEED)
		#crouching_collision.disabled = false
		#standing_collision.disabled = true
	#elif not ray_cast_3d.is_colliding():
		#head.position.y = move_toward(head.position.y, STAND_HEIGHT, delta * LERP_SPEED)
		#crouching_collision.disabled = true
		#standing_collision.disabled = false
		#if Input.is_action_pressed("sprint") and is_on_floor():
			#current_speed = SPRINT_SPEED
		#else:
			#current_speed = WALK_SPEED
#
#func apply_gravity(delta: float) -> void:
	#if not is_on_floor() and has_gravity:
		#if velocity.y > 0.0:
			#velocity.y -= jump_gravity * delta
		#else:
			#velocity.y -= fall_gravity * delta
#
#func handle_jump() -> void:
	#if Input.is_action_just_pressed("jump") and is_on_floor() and can_jump:
		#velocity.y = jump_velocity
#
#func process_movement(delta: float) -> void:
	#if can_walk:
		#var input_dir = Input.get_vector("move_left", "move_right", "move_north", "move_south")
		#var target_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		#direction = lerp(direction, target_direction, delta * LERP_SPEED)
#
		#if direction != Vector3.ZERO:
			#velocity.x = direction.x * current_speed
			#velocity.z = direction.z * current_speed
		#else:
			#velocity.x = move_toward(velocity.x, 0.0, DECELERATION * delta)
			#velocity.z = move_toward(velocity.z, 0.0, DECELERATION * delta)
