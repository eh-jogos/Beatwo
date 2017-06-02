extends "BaseAction.gd"

##########################
# class member variables #
##########################


#########################
#State Custom Functions #
#########################


########################
# State Base Functions #
########################
func enter(entity):
	pass

func input(entity, event):
	if event.is_action_pressed("attack"):
		var next_state = __parent.get_node("Attack")
		__parent.transition_to(next_state)
	pass

func update(entity, delta):
	pass