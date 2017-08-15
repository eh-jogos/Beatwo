extends "PlayerAction__Base.gd"

##########################
# class member variables #
##########################


#########################
#State Custom Functions #
#########################


########################
# State Base Functions #
########################
func enter(entity, variable):
	entity.animator().play("die")
	entity.set_health(0)
	pass