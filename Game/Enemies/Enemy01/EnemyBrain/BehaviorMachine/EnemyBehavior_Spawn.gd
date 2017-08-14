extends "EnemyBehavior__Base.gd"

##########################
# class member variables #
##########################
var animator


##########################
# State Custom Functions #
##########################
func seek():
	var next_state = __parent.get_node("Seek")
	__parent.transition_to(next_state)

########################
# State Base Functions #
########################
func enter(entity, variable):
	animator = entity.get_node("Animator")
	
	animator.play("spawn")