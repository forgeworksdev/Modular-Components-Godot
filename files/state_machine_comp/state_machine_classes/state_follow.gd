extends state
class_name state_follow

@export var npc: CharacterBody2D

var player: CharacterBody2D
var speed: float = 15

func enter():
	player = get_tree().get_first_node_in_group("player")

func exit():
	pass

func update(delta: float):
	pass

func physics_update(delta: float):
	if not npc.is_on_floor():
		npc.velocity += npc.get_gravity() * delta
	var direction = player.position - npc.position
	if direction.length() > 20:
		npc.velocity.x = direction.normalized().x * speed
	else:
		npc.velocity = Vector2()
	if direction.length() > 50:
		transitioned.emit(self, "state_idle")
		npc.velocity = Vector2()
	npc.move_and_slide()
