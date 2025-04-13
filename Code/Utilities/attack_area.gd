class_name AttackArea extends Area2D


var parent:CharacterBody2D = null:
	get:
		if parent == null: parent = get_parent() as CharacterBody2D
		return parent


func get_damage() -> Damage:
	var damage:Damage = Damage.new()
	damage.value = parent.data.damage
	damage.type = parent.data.damage_type
	
	return damage
