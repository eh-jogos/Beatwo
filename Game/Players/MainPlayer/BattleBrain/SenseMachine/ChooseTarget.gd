extends "BaseSense.gd"

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
	pass

func update(entity, delta):
	var enemies = entity.radar().get_overlapping_bodies()
	var enemy_count = enemies.size()
	var distances = []
	var enemies_names = []
	var target
	
	for enemy in enemies:
		enemies_names.push_front(enemy.get_name())
	
	if enemy_count > 0:
		for enemy in enemies:
			var enemy_vector = enemy.get_pos()-entity.get_pos()
			distances.push_front(enemy_vector)
		
#		print("distances: %s" % [distances])
		distances.sort()
#		print("sorted: %s" % [distances])
		target = enemies[0]
	
	print(enemies_names)
	pass