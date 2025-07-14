class_name StateFollow extends State

@export var npc: CharacterBody2D

var player: CharacterBody2D
var speed: float = 15

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	if not npc.is_on_floor():
		npc.velocity += npc.get_gravity() * delta
	var direction: Vector2 = player.position - npc.position
	if direction.length() > 20:
		npc.velocity.x = direction.normalized().x * speed
	else:
		npc.velocity = Vector2()
	if direction.length() > 50:
		switched.emit(self, "state_idle")
		npc.velocity = Vector2()
	npc.move_and_slide()
