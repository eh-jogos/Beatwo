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
		__parent.transition_to(next_state, damage)


########################
# State Base Functions #
########################
func enter(entity, variable):	
	if battle_brain.get_focus() == true:
		battle_brain.set_focus(false)
	
	if !entity.is_connected("internal_damage", self, "take_damage"):
		entity.connect("internal_damage", self, "take_damage",[entity])
	
	pass

func input(entity, event):
	if event.is_action_pressed("attack"):
		var next_state = __parent.get_node("Attack")
		__parent.transition_to(next_state, attack_target)
	
	if event.is_action_pressed("counter") and counter_target.size() > 0:
		var next_state = __parent.get_node("Counter")
		__parent.transition_to(next_state, counter_target)
	pass

func update(entity, delta):
	if entity.animator() != null and !entity.animator().is_playing():
		entity.animator().play("idle")
	
	attack_target = battle_brain.get_attack_target()
	counter_target = battle_brain.get_counter_target()
	pass