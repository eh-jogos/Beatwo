extends "PlayerSense__Base.gd"

##########################
# Class Member Variables #
##########################
onready var battle_brain = __parent.get_node("..")
var radar

########################
# State Base Functions #
########################


########################
# State Base Functions #
########################
func enter(entity):
	radar = entity.radar()
	pass

func update(entity, delta):
	var enemies = entity.radar().get_overlapping_bodies()
	var enemy_count = enemies.size()
	
	if enemy_count > 0:
		var next_state = __parent.get_node("ChooseTarget")
		__parent.transition_to(next_state)
	pass