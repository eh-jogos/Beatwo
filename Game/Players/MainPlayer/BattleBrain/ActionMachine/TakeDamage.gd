extends "BaseAction.gd"

##########################
# class member variables #
##########################
var animator
var health

#########################
#State Custom Functions #
#########################
func combo_damage(damage):
	var next_state = self
	__parent.transition_to(next_state, damage)

func back_to_idle():
	var next_state = __parent.get_node("Idle")
	__parent.transition_to(next_state)


########################
# State Base Functions #
########################
func enter(entity, dmg):
	animator = entity.animator()
	health = entity.get_health()
	
	if !entity.is_connected("internal_damage",self,"combo_damage"):
		entity.connect("internal_damage",self,"combo_damage")
	
	animator.play("take_damage")
	
	health -= dmg
	
	entity.set_health(health)
	pass

func exit(entity):
	if !entity.is_connected("internal_damage",self,"combo_damage"):
		entity.connect("internal_damage",self,"combo_damage")
