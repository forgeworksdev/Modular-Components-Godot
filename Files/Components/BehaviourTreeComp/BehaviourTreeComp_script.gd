## A modular state machine component for controlling AI behavior.
## Manages state transitions and execution flow for AI-driven entities.
class_name BehaviourTreeComponent extends Node

## Defines in which state the behaviour tree starts in.
@export var default_state: State

## Node which the states will target.
@export var target: Node

var current_state: State
var state_database: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			state_database[child.name.to_lower()] = child
			child.switched.connect(_on_child_switched)
	if default_state:
		default_state.enter()
		current_state = default_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _on_child_switched(state: State, new_state_name: String) -> void:
	if state != current_state:
		return
	var new_state: State = state_database.get(new_state_name.to_lower())
	if !new_state:
		return
	if current_state:
		current_state.exit()
	new_state.enter()
	current_state = new_state
