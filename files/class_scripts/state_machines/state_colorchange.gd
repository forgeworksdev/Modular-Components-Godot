extends state
class_name state_colorchange

@export var enemy: CharacterBody2D

var funni_numbah: float = 0

func enter():
	var icon = enemy.get_node("Icon")
	icon.modulate = Color(0.0, 0.243, 0.106)

func exit():
	pass

func update(delta: float):
	funni_numbah += .5
	print(str(funni_numbah))
	if funni_numbah >= 20:
		transitioned.emit(self, "state_colorchange2")
		funni_numbah = 0

func physics_update(delta: float):
	pass
