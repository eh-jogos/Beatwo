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

# Method executed everytime the FSM "enters" this state
func enter(entity, variable):
	# Plays death animation
	entity.animator().play("die")
	
	# Sets the health to zero to prevent it from becoming negative
	entity.set_health(0)