extends "BaseAction.gd"

##########################
# class member variables #
##########################
onready var battle_brain = __parent.get_node("..")
var attack_target = null
var counter_target = []

#########################
#State Custom Functions #
#########################
func take_damage(damage, entity):
	if battle_brain.get_vulnerability():
		if entity.is_connected("internal_damage", self, "take_damage"):
			entity.disconnect("internal_damage", self, "take_damag")
		var next_state = __parent.get_node("TakeDamage")
		__parent.set_state(next_state)
		__parent.__state.enter(entity, damage)


########################
# State Base Functions #
########################
func enter(entity):	
	if !entity.is_connected("internal_damage", self, "take_damage"):
		entity.connect("internal_damage", self, "take_damage",[entity])
	
	if entity.animator() != null:
		entity.animator().play("idle")
	pass

func input(entity, event):
	if event.is_action_pressed("attack"):
		var next_state = __parent.get_node("Attack")
		__parent.transition_to(next_state)
	
	if event.is_action_pressed("counter") and counter_target.size() > 0:
		var next_state = __parent.get_node("Counter")
		__parent.transition_to(next_state)
	pass

func update(entity, delta):
	
	attack_target = battle_brain.get_attack_target()
	counter_target = battle_brain.get_counter_target()
	pass