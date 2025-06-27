extends Node
# The starting range of possible offsets using random values
@export var RANDOM_SHAKE_STRENGTH: int = 5
# Multiplier for lerping the shake strength to zero
@export var SHAKE_DECAY_RATE: float = 6.0

@export var can_shake: bool = false

@export var camera: Camera2D
@onready var rand: RandomNumberGenerator = RandomNumberGenerator.new()

var shake_strength: float = 0.0

func _ready() -> void:
	rand.randomize()

func apply_shake() -> void:
	shake_strength = RANDOM_SHAKE_STRENGTH

func _process(delta: float) -> void:
	if camera and can_shake:
		shake_strength = lerp(shake_strength, 0.0, SHAKE_DECAY_RATE * delta)
		camera.offset = get_random_offset()
	elif can_shake:
		print("No camera specified in " + name)

func get_random_offset() -> Vector2:
	return Vector2(
	rand.randf_range(-shake_strength, shake_strength),
	rand.randf_range(-shake_strength, shake_strength)
	)
