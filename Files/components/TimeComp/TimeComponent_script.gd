class_name TimeComponent
extends Node

@export var enabled: bool = true

## Time scale factor. 1.0 means 1 second real = 1 second game time.
@export var time_scale: float = 60.0

## Total time in minutes since the start of the game.
var total_minutes: float = 0.0

## Minutes in a full in-game day (24 * 60).
const MINUTES_PER_DAY: float = 1440.0

var hour: int = 0
var minute: int = 0
var days: int = 0
var time_ratio: float = 0.0

func _process(delta: float) -> void:
	if not enabled:
		return
	total_minutes += delta * time_scale

	var days_passed := int(floor(total_minutes / MINUTES_PER_DAY))
	if days_passed > 0:
		days += days_passed
		total_minutes = fmod(total_minutes, MINUTES_PER_DAY)

	_update_time_variables()

	var time_string := "%02d:%02d - %.4f - Day %d" % [hour, minute, time_ratio, days]
	print(time_string)

func _update_time_variables() -> void:
	time_ratio = total_minutes / MINUTES_PER_DAY
	hour = int(total_minutes / 60.0)
	minute = int(fmod(total_minutes, 60.0))

func reset_time() -> void:
	total_minutes = 0.0
	days = 0
	_update_time_variables()
