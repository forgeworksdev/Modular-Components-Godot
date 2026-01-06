## A modular health component supporting healing, damage, death events, invincibility frames, and heart-based UI.
class_name HealthComponent extends Node


@export_subgroup("Properties")

var _max_health: int = 100
## Maximum health.
@export var max_health: int:
	set(value):
		_max_health = max(1, value)
		_health = clamp(_health, 0, _max_health)
	get:
		return _max_health


var _health: int = 100
##Current health value. Clamped between 0 and max_health.
@export var health: int:
	set(value):
		_health = clamp(value, 0, max_health)
	get:
		return _health

var _max_damage: int = 100
##Maximum allowed damage per hit. Further damage is ignored.
@export var max_damage: int = 100:
	set(value):
		_max_damage = max(value, 0)
		return _max_damage
	get:
		return _max_damage


## Enables visual heart-based UI updates.
#@export var uses_hearts: bool = false

@export_subgroup("Flags")
@export var is_alive: bool:
	get():
		return health > 0

@export var is_invulnerable: bool = false

## Duration of invincibility (in seconds).
@export var i_time: float = 0

## Internal i_timer used for invincibility logic.
var i_timer: Timer


##Emitted when damage is taken.
signal damaged(ref: Node, amount: int, source: Node)

##Fires when health reaches 0.
signal death(ref: Node, source: Node)

##Fires when this component is cured.
signal cured(ref: Node, amount: int, source: Node)

##Fires when this health is changed.
signal health_changed(ref: Node, previous: int, current : int, max: int)


func _ready() -> void:
	health = clamp(health, 0, max_health)

	if not i_timer:
		i_timer = create_timer(i_time, true)

func create_timer(wait_time: float = 1, oneshot: bool = false, timeout_method: Callable = _on_timer_timeout) -> Timer:
	var new_timer: Timer = Timer.new()
	new_timer.one_shot = oneshot
	new_timer.wait_time = wait_time
	new_timer.timeout.connect(timeout_method)
	add_child(new_timer)
	return new_timer

func apply_heal(amount: int, multiplier: float = 1.0, source: Node = null) -> void:
	var previous_health: int = health
	if is_alive and amount > 0:
		var new_amount: int = int(amount * multiplier)
		health = min(health + new_amount, max_health)
		cured.emit(self, new_amount, source)

	if health != previous_health:
		health_changed.emit(self, previous_health, health, max_health)

func apply_damage(amount: int, multiplier: float = 1.0, source: Node = null) -> void:
	var previous_health: int = health
	if !is_invulnerable and amount > 0 and is_alive:
		var new_amount: int = int(amount * multiplier)
		new_amount = min(new_amount, max_damage)
		health = max(health - new_amount, 0)
		is_invulnerable = true
		i_timer.start()
		damaged.emit(self, new_amount, source)
		if health <= 0 and is_alive:
			apply_death(false, source)

	if health != previous_health:
		health_changed.emit(self, previous_health, health, max_health)

func apply_death(override_invulnerability: bool = false, source: Node = null) -> void:
	var previous_health: int = health
	if (!is_invulnerable or override_invulnerability) and is_alive:
		health = 0
		#is_alive = false
		death.emit(self, source)

	if health != previous_health:
		health_changed.emit(self, previous_health, health, max_health)

func reset() -> void:
	var previous_health: int = health
	health = max_health
	is_invulnerable = false
	#is_alive = true

	if health != previous_health:
		health_changed.emit(self, previous_health, health, max_health)

func _on_timer_timeout() -> void:
	is_invulnerable = false
