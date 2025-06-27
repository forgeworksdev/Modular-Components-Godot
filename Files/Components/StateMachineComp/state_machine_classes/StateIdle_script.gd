extends State
class_name StateIdle

@export var npc: CharacterBody2D
@export var sprite: AnimatedSprite2D

var player: CharacterBody2D

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	sprite.play("default")

func exit() -> void:
	sprite.stop()

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	var direction: Vector2 = player.position - npc.position
	if direction.length() < 50:
		transitioned.emit(self, "state_follow")
