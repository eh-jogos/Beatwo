extends "EnemyBehavior__Base.gd"

##########################
# class member variables #
##########################
# here I have to use it as a variable because if I try to use the "animator()" method I get an error because appearently it hasn't been loaded yet
var animator

##########################
# State Custom Functions #
##########################
# at the end of the "spawn" animation, it calls this method
# which transitions the entity to the seek state
func seek():
	var next_state = __parent.get_node("Seek")
	__parent.transition_to(next_state)

########################
# State Base Functions #
########################

# Method executed everytime the FSM "enters" this state
func enter(entity, variable):
	animator = entity.get_node("Animator")
	
	# plays spawn animation
	animator.play("spawn")