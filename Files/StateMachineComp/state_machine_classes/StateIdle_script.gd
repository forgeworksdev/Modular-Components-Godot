extends State
class_name StateIdle

@export var npc: CharacterBody2D
@export var sprite: AnimatedSprite2D

var player: CharacterBody2D

func enter():
	player = get_tree().get_first_node_in_group("player")
	sprite.play("default")

func exit():
	sprite.stop()

func update(delta: float):
	pass

func physics_update(delta: float):
	var direction = player.position - npc.position
	if direction.length() < 50:
		transitioned.emit(self, "state_follow")
