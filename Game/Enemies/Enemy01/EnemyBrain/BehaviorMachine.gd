extends Node

##########################
# class member variables #
##########################
onready var __state = self.get_node("Battle")
onready var entity = self.get_node("../..")
onready var debug = entity.get_node("DebugPanels/BehaviorMachine/DebugText")


#############################
# Custom Method Definitions #
#############################
func transition_to(next_state, variable = null):
	self.__state.exit(entity)
	self.__state = next_state
	self.debug.set_text(__state.get_name())
	self.__state.enter(entity, variable)



###########################
# Engine Standard Methods #
###########################
func _ready():
	set_process(true)
	
	self.debug.set_text(__state.get_name())
	self.__state.enter(entity, null)
	
	pass

func _process(delta):
	self.__state.update(self, delta)
