## A reusable component for applying dynamic screen shake to a Camera2D node.
## Attach this to any node in your scene and assign a Camera2D to apply camera shake effects.
@tool
class_name ScreenShakeEffectComponent extends Node

@export var enabled: bool = false

## The initial intensity of the shake when triggered. Higher values cause stronger shake offsets.
## Represents the maximum range (in pixels) the camera can be randomly offset per frame.
@export var random_shake_strength: float = 5.0

## Controls how quickly the shake strength decays over time.
## Higher values make the shake fade out faster.
@export var shake_decay_rate: float = 6.0

## Reference to the Camera2D node that will receive the shake effect.
@export var camera: Camera2D

## Internal random number generator used to calculate random shake offsets.
@onready var rng := RandomNumberGenerator.new()

## Current shake intensity. Dynamically lerped toward zero after shake is applied.
var shake_strength: float = 0.0

func _ready() -> void:
	rng.randomize()

func apply_shake() -> void:
	shake_strength = random_shake_strength

func _process(delta: float) -> void:
	if not enabled:
		return

	if not is_instance_valid(camera):
		push_warning("Camera not assigned to %s" % name)
		return

	if shake_strength > 0.01:
		shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)
		camera.offset = get_random_offset()
	else:
		camera.offset = Vector2.ZERO

func get_random_offset() -> Vector2:
	return Vector2(
		rng.randf_range(-shake_strength, shake_strength),
		rng.randf_range(-shake_strength, shake_strength)
	)
