extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_hit_box_component_area_entered(area):
	if area is HitBoxComponent:
		var attack = Attack.new()
		attack.attack_damage = 100
		area.damage(attack)
