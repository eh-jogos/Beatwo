extends Node

# This Base script is to easily add common funcionality to all States of a particular FSM
# Each FSM has a customized Base script according to it's needs

##########################
# Class Member Variables #
##########################

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var __parent = self.get_node("..")  # Parent node so the states can easily access their Parent Machinhe


#########################
#State Custom Functions #
#########################


########################
# State Base Functions #
########################

# Here are Basic Mehtods all States need to have, in case the parent machine delegates something to them.
# There's no functionality in them, as each state needs to overwrite the ones that will be useful for them.
# The ones that they don't overwrite will fallback to these blank methods, preventing errors

# Basic "enter" method, executed everytime the FSM "enters" a state
func enter(entity, variable):
	pass

# Basic "input" method, executed whenever an input is delegated to a state
func input(entity, event):
	pass

# Basic "update" method, executede whenever the processing is delegated to a state
func update(entity, delta):
	pass

# Basic "exit" method, executed whenever the FSM exits a state
func exit(entity):
	pass