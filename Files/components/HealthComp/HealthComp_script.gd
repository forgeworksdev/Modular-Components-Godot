## A modular health component supporting healing, damage, death events, invincibility frames, and heart-based UI.
@tool
class_name HealthComponent extends Node

@export_subgroup("Properties")

@export var enabled: bool = true


## Maximum [member health].
@export_range(0, 100000, 1) var max_health: int:
	set(value):
		max_health = max(1, value)
		health = clamp(health, 0, max_health)

##Current health value. Clamped between 0 and [member max_health].
@export var health: int:
	set(value):
		health = clamp(value, 0, max_health)

##Maximum allowed damage per hit. Further damage is ignored.
@export var max_damage: int = 100:
	set(value):
		max_damage = max(value, 0)

@export_subgroup("Flags")
@export var is_alive: bool:
	get():
		return health > 0

## If true, will negate all damage.
@export var is_invincible: bool = false

## Time of recovery after damage in which invulnerability will be applied (in seconds).
@export var i_time: float = 0:
	set(value):
		i_time = max(value, 0.0)
		if invincibility_timer:
			invincibility_timer.wait_time = i_time

## Internal invincibility_timer used for invincibility logic.
var invincibility_timer: Timer

var _is_invulnerable: bool = false

##Fires when damage is taken.
signal damaged(ref: Node, amount: int, source: Node)

##Fires when health reaches 0.
signal death(ref: Node, source: Node)

##Fires when cured.
signal cured(ref: Node, amount: int, source: Node)

##Fires when this health is modified in any way.
signal health_changed(ref: Node, previous: int, current : int, max: int)


func _init() -> void:
	health = clamp(health, 0, max_health)

func _ready() -> void:
	if not invincibility_timer:
		if i_time > 0:
			invincibility_timer = _create_timer(i_time, true)
		else:
			_is_invulnerable = false

func _create_timer(wait_time: float = 1, oneshot: bool = false, timeout_method: Callable = _on_timer_timeout) -> Timer:
	var new_timer: Timer = Timer.new()
	new_timer.one_shot = oneshot
	new_timer.wait_time = wait_time
	new_timer.timeout.connect(timeout_method)
	add_child(new_timer)
	return new_timer

## Returns true if alive, not invulnerable and not invincible.
func can_take_damage() -> bool:
	return enabled and is_alive and not is_invincible and not _is_invulnerable

## Increases health
func heal(amount: int, multiplier: float = 1.0, source: Node = null) -> void:
	if !enabled:
		return

	var new_amount: int = int(amount * multiplier)
	var previous_health: int = health
	if new_amount <= 0:
		return

	if is_alive:

		health = min(health + new_amount, max_health)
		cured.emit(self, new_amount, source)

	if health != previous_health:
		health_changed.emit(self, previous_health, health, max_health)

func damage(amount: int, multiplier: float = 1.0, source: Node = null) -> void:
	if !enabled:
		return

	var new_amount: int = int(amount * multiplier)
	var previous_health: int = health
	if new_amount <= 0:
		return

	if can_take_damage:
		new_amount = min(new_amount, max_damage)
		health = max(health - new_amount, 0)
		if health <= 0:
			kill(false, source)

		_is_invulnerable = true
		if invincibility_timer:
			invincibility_timer.start()
		damaged.emit(self, new_amount, source)

	if health != previous_health:
		health_changed.emit(self, previous_health, health, max_health)

func kill(override_invincibility: bool = false, source: Node = null) -> void:
	if !enabled:
		return

	var previous_health: int = health
	if (!_is_invulnerable or override_invincibility) and is_alive:
		health = 0
		death.emit(self, source)

	if health != previous_health:
		health_changed.emit(self, previous_health, health, max_health)

func reset() -> void:
	var previous_health: int = health
	health = max_health
	_is_invulnerable = false

	if health != previous_health:
		health_changed.emit(self, previous_health, health, max_health)

func _on_timer_timeout() -> void:
	_is_invulnerable = false
