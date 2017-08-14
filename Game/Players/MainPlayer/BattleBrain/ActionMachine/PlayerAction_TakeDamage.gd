extends "PlayerAction__Base.gd"

##########################
# class member variables #
##########################
onready var battle_brain = __parent.get_node("..")

var animator
var health

#########################
#State Custom Functions #
#########################
func combo_damage(damage):
	if battle_brain.get_vulnerability():
		var next_state = self
		__parent.transition_to(next_state, damage)

func back_to_idle():
	battle_brain.set_vulnerability(false)
	
	var next_state = __parent.get_node("Idle")
	__parent.transition_to(next_state)


########################
# State Base Functions #
########################
func enter(entity, dmg):
	battle_brain.clean_counter_target()
	
	animator = entity.animator()
	health = entity.get_health()
	
	if !entity.is_connected("internal_damage",self,"combo_damage"):
		entity.connect("internal_damage",self,"combo_damage")
	
	animator.play("take_damage")
	
	health -= dmg
	
	if health <= 0:
		var next_state = __parent.get_node("Dead")
		__parent.transition_to(next_state)
	else:
		entity.set_health(health)
	
	pass

func exit(entity):
	if entity.is_connected("internal_damage",self,"combo_damage"):
		entity.disconnect("internal_damage",self,"combo_damage")
