extends Enemy_Parent
class_name EnemyGrunt


func initialize():
	max_health = 50.0
	speed = 30
	
	# weapon and behavior are already set up as child nodes in the scene
	# Just grab references if needed
	if not weapon:
		weapon = get_node_or_null("Weapon")
	if not behavior:
		behavior = get_node_or_null("Behavior")

func dying():
	super.dying()


func _on_enemy_collision_destroyed() -> void:
	queue_free()


func _on_enemy_collision_damaged(damage: float) -> void:
	Globalpointscript.score += 10
	super.take_damage(damage)
