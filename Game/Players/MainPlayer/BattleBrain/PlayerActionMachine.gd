extends Node

##########################
# Class Member Variables #
##########################

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var __state = self.get_node("Idle") # Initial State for the FSM
onready var player = self.get_node("../..") # Player Node
onready var debug = player.get_node("DebugPanels/ActionMachine/DebugText") # Player's Debug Panels  for this FSM

#############################
# Custom Method Definitions #
#############################

# Basic state transitioning method
## It takes a optional parameter besides the next state, that is consumed by some states
## It also executes the "exit" method of the current state before changing states and executing the "enter" method for the new state
func transition_to(state, variable = null):
	self.__state.exit(player)
	self.__state = state
	debug.set_text(state.get_name()) # debug text to check state's transitionings
	self.__state.enter(player, variable)

###########################
# Engine Standard Methods #
###########################


# Called every time the node is added to the scene.
func _ready():
	set_process(true)
	set_process_input(true)
	
	self.transition_to(__state) # Once ready, transitions to the initial state

# Called every time a input event is generated
func _input(event):
	self.__state.input(player, event) # delegates input to the current state

# Called every time a frame is drawn, not necessarily at regular intervals
## delta is ammount of time elapsed since last time it executed.
func _process(delta):
	self.__state.update(player, delta) # delegates processing to the current state
