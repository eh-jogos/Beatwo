extends "res://Players/MainPlayer/BaseState.gd"

##########################
# Class Member Variables #
##########################


########################
# State Base Functions #
########################


########################
# State Base Functions #
########################
func enter(entity):
	entity.set_process(true)
	entity.set_process_input(true)
	pass

func input(entity, event):
	if event.is_action_pressed("attack"):
		var state = __parent.get_node("AttackTarget")
		__parent.transition_to(state)
	pass

func update(entity, delta):
	var enemies = entity.radar().get_overlapping_bodies()
	var enemy_count = enemies.size()
	var distances = []
	var enemies_names = []
	var target
	
	for enemy in enemies:
		enemies_names.push_front(enemy.get_name())
	
	if enemy_count > 1:
		for enemy in enemies:
			var enemy_vector = enemy.get_pos()-entity.get_pos()
			distances.push_front(enemy_vector)
		
#		print("distances: %s" % [distances])
		distances.sort()
#		print("sorted: %s" % [distances])
		target = enemies[0]
	
	print(enemies_names)
	pass