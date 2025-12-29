## Hurtbox.gd
class_name HurtboxComponent extends Area2D

@export var health_component: HealthComponent

@export var damage_multiplier: float = 1.0 #@FIXME make into float

@export var heal_multiplier: float = 1.0 #@FIXME make into float
## Optional group-based hit filtering
@export var allowed_attack_groups: Array[StringName] = []

#func _ready() -> void:
	#area_entered.connect(_on_area_entered)
#
#func _on_area_entered(area: Area2D) -> void:
	#if health_component == null:
		#push_warning(self.name + " Doesn't have a HealComp.")
		#return
#
	#if area.is_in_group("hitbox"):
		#if allowed_attack_groups.size() > 0:
			#for group in allowed_attack_groups:
				#if area.is_in_group(group):
					#health_component.apply_damage(area.damage, damage_multiplier, area.owner)
					#break
		#else:
			#health_component.apply_damage(area.damage, damage_multiplier, area.owner)
#
	#elif area.is_in_group("healbox"):
		#health_component.apply_heal(area.heal_amount, heal_multiplier, area.owner)

@export var damage_interval: float = 0.01
var damage_timer: float = 0.0

func _physics_process(delta: float) -> void:
	damage_timer -= delta
	if damage_timer <= 0.0:
		damage_timer = damage_interval
		for area in get_overlapping_areas():
			if area.is_in_group("hitbox"):
				if allowed_attack_groups.size() > 0:
					for group in allowed_attack_groups:
						if area.is_in_group(group):
							health_component.apply_damage(area.damage, damage_multiplier, area.owner)
							break
				else:
					health_component.apply_damage(area.damage, damage_multiplier, area.owner)

			elif area.is_in_group("healbox"):
				health_component.apply_heal(area.heal_amount, heal_multiplier, area.owner)
