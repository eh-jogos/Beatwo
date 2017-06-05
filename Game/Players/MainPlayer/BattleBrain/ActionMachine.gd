extends Node

##########################
# Class Member Variables #
##########################

onready var __state = self.get_node("Idle")
onready var player = self.get_node("../..")
onready var debug = player.get_node("DebugPanels/ActionMachine/DebugText")

#############################
# Custom Method Definitions #
#############################

func transition_to(state):
	self.set_state(state)
	debug.set_text(state.get_name())
	self.__state.enter(player)
	pass

func set_state(state):
	self.__state = state

###########################
# Engine Standard Methods #
###########################

func _ready():
	# Initialization here
	set_process(true)
	set_process_input(true)
	
	self.transition_to(__state)
	pass

func _input(event):
	self.__state.input(player, event)
	pass

func _process(delta):
	self.__state.update(player, delta)
	pass
