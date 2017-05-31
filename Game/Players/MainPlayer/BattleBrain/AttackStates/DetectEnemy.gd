extends "res://Players/MainPlayer/BaseState.gd"

# class member variables go here, for example:

# State Base Functions
func enter(entity):
	entity.set_process(true)
	entity.set_process_input(true)
	pass

func input(entity, event):
	if event.is_action_pressed("attack"):
		var state = __parent.get_node("AttackTarget")
		__parent.transition_to(state)
	pass

func update(entity, delta):
	pass