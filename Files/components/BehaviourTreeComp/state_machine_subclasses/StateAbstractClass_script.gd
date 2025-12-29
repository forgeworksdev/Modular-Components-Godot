@abstract class_name State extends Node

##
@warning_ignore("unused_signal")
signal switched(current_state: State, new_state: String)

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass
