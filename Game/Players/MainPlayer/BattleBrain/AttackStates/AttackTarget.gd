extends "res://Players/MainPlayer/BaseState.gd"

##########################
# class member variables #
##########################
var myTimer

#########################
#State Custom Functions #
#########################

# get's called at the end of attack animation
func back_to_detect():
	var state = __parent.get_node("DetectEnemy")
	__parent.transition_to(state)
	pass

########################
# State Base Functions #
########################
func enter(entity):
	entity.animator().play("attack1")
	pass

func input(entity, event):
	pass

func update(entity, delta):
	pass