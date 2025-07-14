class_name GUIComponent extends Control

@export var pause_screen: Control
var is_game_paused: bool = false

func _process(delta: float) -> void:
#	if OS.is_debug_build():
	queue_redraw()

func _ready() -> void:
	if pause_screen:
		pause_screen.hide()
		pause_screen.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("return"):
		is_game_paused = not is_game_paused
		print("Is game paused? %s" % is_game_paused)
		get_tree().paused = is_game_paused
		if pause_screen:
			pause_screen.visible = is_game_paused

@onready var font: Font = ThemeDB.fallback_font

func _draw() -> void:
	draw_string(font, Vector2(5, 10), "FPS:  %d" % Engine.get_frames_per_second(), HORIZONTAL_ALIGNMENT_FILL, -1, 5, Color.WHITE)
