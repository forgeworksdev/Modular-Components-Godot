## A modular state machine component for controlling AI behavior.
## Manages state transitions and execution flow for AI-driven entities.
class_name FiniteStateComponent extends Node

@export var enabled: bool

## Defines in which state the behaviour tree starts in.
@export var default_state: State

## Node which the states will target.
@export var target: Node

var current_state: State
var state_database: Dictionary = {}

func _ready() -> void:
	if default_state and default_state.get_parent() != self:
		assert(default_state.get_parent() == self, "BehaviourTreeComponent: Default state must be a child.")
	for child in get_children():
		if child is State:
			state_database[child.name.to_lower()] = child
			child.switched.connect(_on_state_switched)
	if default_state:
		default_state.enter()
		current_state = default_state

func _process(delta: float) -> void:
	if not enabled or not current_state:
		return

	current_state.update(delta)

func _physics_process(delta: float) -> void:
	if not enabled or not current_state:
		return

	current_state.physics_update(delta)

func _on_state_switched(state: State, new_state_name: String) -> void:
	if state != current_state:
		return
	var new_state: State = state_database.get(new_state_name.to_lower())
	if !new_state:
		push_error("BehaviourTreeComponent: State not found. Transition aborted!")
		return
	if current_state:
		current_state.exit()
	new_state.enter()
	new_state.target = target
	current_state = new_state

func reset() -> void:
	if current_state:
		current_state.exit()
	current_state = default_state
	if current_state:
		current_state.enter()
