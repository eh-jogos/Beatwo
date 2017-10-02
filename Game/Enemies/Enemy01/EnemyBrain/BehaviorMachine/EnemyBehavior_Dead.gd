extends "EnemyBehavior__Base.gd"

##########################
# class member variables #
##########################

# Internal state variables
var animator # enemy main animation player node

##########################
# State Custom Functions #
##########################



########################
# State Base Functions #
########################

# Method executed everytime the FSM "enters" this state
func enter(entity, is_flipped):
	# emits enemy_dead signal, which makes the player change target
	# and clean it's counter target list
	entity.emit_signal("enemy_dead")
	
	# Initializes internal variable
	animator = entity.get_node("Animator")
	
	# Chooses correct dying animation based on entity direction
	if is_flipped:
		animator.play("dying_flip")
	else:
		animator.play("dying")
	pass