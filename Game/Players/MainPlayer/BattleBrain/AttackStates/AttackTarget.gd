extends "res://Players/MainPlayer/BaseState.gd"

# class member variables go here, for example:
var myTimer

#State Custom Functions
func back_to_detect():
	if myTimer.is_connected("timeout",self,"back_to_detect"):
		myTimer.disconnect("timeout",self,"back_to_detect")
	var state = __parent.get_node("DetectEnemy")
	__parent.transition_to(state)
	
	pass

# State Base Functions
func enter(entity):
	myTimer = Timer.new()
	myTimer.set_wait_time(0.2)
	myTimer.set_one_shot(true)
	if !myTimer.is_connected("timeout",self,"back_to_detect"):
		myTimer.connect("timeout",self,"back_to_detect")
	add_child(myTimer)
	myTimer.start()
	pass

func input(entity, event):
	pass

func update(entity, delta):
	pass