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
	
	if enemy_count > 0:
		var next_state = __parent.get_node("ChooseTarget")
		__parent.transition_to(next_state)
		
	pass