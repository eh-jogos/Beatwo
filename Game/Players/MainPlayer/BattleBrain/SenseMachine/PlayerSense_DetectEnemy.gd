extends "PlayerSense__Base.gd"

##########################
# Class Member Variables #
##########################

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var battle_brain = __parent.get_node("..") # Gets BattleBrain node 

########################
# State Base Functions #
########################


########################
# State Base Functions #
########################

# Method that updates every frame, or every processing interval
func update(entity, delta):
	# Gets all "bodies" that are overlapping with the enemy detection area (radar)
	var enemies = entity.radar().get_overlapping_bodies()
	
	# Gets the quantity of enemies
	var enemy_count = enemies.size()
	
	# I there is One enemy or more in the enemy detection area, it transitions to "ChooseTarget" state
	if enemy_count > 0:
		var next_state = __parent.get_node("ChooseTarget")
		__parent.transition_to(next_state)