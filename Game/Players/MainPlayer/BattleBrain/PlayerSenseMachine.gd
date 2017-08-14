extends Node

##########################
# Class Member Variables #
##########################

onready var __state = self.get_node("DetectEnemy")
onready var player = self.get_node("../..")
onready var debug = player.get_node("DebugPanels/SenseMachine/DebugText")


#############################
# Custom Method Definitions #
#############################

func transition_to(state):
	self.__state = state
	debug.set_text(state.get_name())
	self.__state.enter(player)
	pass


###########################
# Engine Standard Methods #
###########################

func _ready():
	# Initialization here
	set_process(true)
	
	self.transition_to(__state)
	pass

func _process(delta):
	self.__state.update(player, delta)
	pass