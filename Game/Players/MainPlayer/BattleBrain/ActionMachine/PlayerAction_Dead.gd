extends "PlayerAction__Base.gd"

##########################
# class member variables #
##########################
onready var battle_brain = __parent.get_node("..")
var attack_target = null
var counter_target = []

var health

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