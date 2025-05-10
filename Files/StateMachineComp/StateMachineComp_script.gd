extends Node

@export var default_state: State

var cur_state: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_child_transitioned)
	if default_state:
		default_state.enter()
		cur_state = default_state

func _process(delta: float) -> void:
	if cur_state:
		cur_state.update(delta)

func _physics_process(delta: float) -> void:
	if cur_state:
		cur_state.physics_update(delta)

func _on_child_transitioned(State, new_state_name):
	if State != cur_state:
		return
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	if cur_state:
		cur_state.exit()
	new_state.enter()
	cur_state = new_state
