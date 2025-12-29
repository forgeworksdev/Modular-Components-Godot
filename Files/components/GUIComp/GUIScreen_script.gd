## Modular GUI Screen for use with [GUIComponent]
class_name GUIScreen extends Control

@warning_ignore("unused_signal")
signal switch

@export_subgroup("Screen Mode")
##Test
@export_enum("overlay", "exclusive", "free") var stacklable: int = 0


func enter() -> void:
	pass

func update() -> void:
	pass

func exit() -> void:
	pass
