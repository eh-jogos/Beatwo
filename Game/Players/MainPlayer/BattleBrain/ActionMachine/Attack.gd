extends "BaseAction.gd"

##########################
# class member variables #
##########################


#########################
#State Custom Functions #
#########################

# get's called at the end of attack animation
func back_to_idle():
	var state = __parent.get_node("Idle")
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