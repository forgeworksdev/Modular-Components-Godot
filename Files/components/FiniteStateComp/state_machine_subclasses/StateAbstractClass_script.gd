@abstract class_name State extends Node

@warning_ignore("unused_signal")
signal switched(current_state: State, new_state: String)

var target: Node

@abstract func enter() -> void
@abstract func exit() -> void
@abstract func update(delta: float) -> void
@abstract func physics_update(delta: float) -> void
