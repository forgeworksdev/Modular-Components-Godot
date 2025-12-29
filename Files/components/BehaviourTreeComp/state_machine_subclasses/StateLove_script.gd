extends State
class_name StateLove

@export var npc: CharacterBody2D

func enter() -> void:
	pass

func exit() -> void:
	sprite.stop()

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	var direction: Vector2 = player.position - npc.position
	if direction.length() < 50:
		switched.emit(self, "state_follow")
