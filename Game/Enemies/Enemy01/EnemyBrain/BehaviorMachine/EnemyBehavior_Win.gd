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
func enter(entity, is_flipped):
	entity.animator().play("win")
