extends Area3D

class_name HitBoxComponent
@export var healtComponent: HealthComponent

func damage(attack:Attack):
	if healtComponent:
		healtComponent.damage(attack)
