extends "BaseBehavior.gd"

##########################
# class member variables #
##########################
var animator

##########################
# State Custom Functions #
##########################



########################
# State Base Functions #
########################
func enter(entity, is_flipped):
	entity.emit_signal("enemy_dead")
	animator = entity.get_node("Animator")
	
	if is_flipped:
		animator.play("dying_flip")
	else:
		animator.play("dying")
	pass