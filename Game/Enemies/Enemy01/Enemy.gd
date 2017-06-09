extends KinematicBody2D

##########################
# class member variables #
##########################
onready var animator = self.get_node("Animator")
onready var target_animator = self.get_node("TargetAnimator")

signal attack_player(damage)



#############################
# Custom Method Definitions #
#############################
func take_damage(dmg):
#	animator.play("dying")
	self.queue_free()
#	var current_pos = self.get_pos()
#	self.set_pos(Vector2(current_pos.x+110,current_pos.y))
	pass

func set_target(boolean):
	if boolean:
		if !target_animator.get_current_animation() == "active":
			target_animator.play("active")
	else:
		if !target_animator.get_current_animation() == "inactive":
			target_animator.play("inactive")

###########################
# Engine Standard Methods #
###########################

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	animator.play("idle")
	pass
