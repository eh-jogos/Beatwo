extends "EnemyBehavior__Base.gd"

##########################
# class member variables #
##########################

##########################
# State Custom Functions #
##########################



########################
# State Base Functions #
########################

# Method executed everytime the FSM "enters" this state
func enter(entity, is_flipped):
	entity.animator().play("win")
