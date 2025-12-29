## A
class_name GUIComponent extends MarginContainer

@export var default_screen: GUIScreen
var screens: Array[GUIScreen]
var shown_screens: Array[GUIScreen]
var focused_screen: GUIScreen
var is_game_paused: bool = false

func _ready() -> void:
	for child in self.get_children():
		if child is GUIScreen:
			pass
	if default_screen:
		shown_screens.append(default_screen)
		default_screen.enter()

func _process(delta: float) -> void:
	queue_redraw()
	if shown_screens:
		shown_screens[shown_screens.size()].update()

func open_screen(screen: GUIScreen) -> void:
	shown_screens.append(screen)

func close_screen(screen: GUIScreen) -> void:
	pass

func play_game() -> void:
	get_tree().paused = false

func pause_game() -> void:
	get_tree().paused = true

func _on_child_switched() -> void:
	pass
#func _ready() -> void:
	#if pause_screen:
		#pause_screen.hide()
		#pause_screen.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
#
#func _input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("return"):
		#is_game_paused = not is_game_paused
		#print("Is game paused? %s" % is_game_paused)
		#get_tree().paused = is_game_paused
		#if pause_screen:
			#pause_screen.visible = is_game_paused
#
#@onready var font: Font = ThemeDB.fallback_font
#
#func _draw() -> void:
	#draw_string(font, Vector2(5, 10), "FPS:  %d" % Engine.get_frames_per_second(), HORIZONTAL_ALIGNMENT_FILL, -1, 5, Color.WHITE)
