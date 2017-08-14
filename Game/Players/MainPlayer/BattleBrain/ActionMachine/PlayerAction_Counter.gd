extends "PlayerAction__Base.gd"

##########################
# class member variables #
##########################
onready var battle_brain = __parent.get_node("..")

var counter_damage
var targets

#########################
#State Custom Functions #
#########################
func back_to_idle():
	var next_state = __parent.get_node("Idle")
	__parent.transition_to(next_state)

func hit_counter():
	for enemy in targets:
		enemy.take_damage(counter_damage)

########################
# State Base Functions #
########################
func enter(entity, counter_target):
	battle_brain.set_vulnerability(false)
	counter_damage = 2
	
	targets = counter_target
	battle_brain.clean_counter_target()
	
	entity.animator().play("counter1")
	pass

func exit(entity):
	pass