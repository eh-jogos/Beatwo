extends Node

##########################
# class member variables #
##########################
onready var __player = self.get_node("../../Player")
onready var __player_pos = __player.get_pos()


#############################
# Custom Method Definitions #
#############################
func get_player():
	return __player

func get_player_pos():
	return __player_pos


###########################
# Engine Standard Methods #
###########################

func _ready():
	pass
