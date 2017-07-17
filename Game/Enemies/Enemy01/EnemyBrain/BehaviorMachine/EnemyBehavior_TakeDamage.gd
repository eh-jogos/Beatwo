extends "BaseBehavior.gd"

##########################
# class member variables #
##########################
var animator
var is_flipped
var health

##########################
# State Custom Functions #
##########################
func recover():
	animator.play("idle")
	back_to_battle()

func combo_damage(damage):
	var next_state = self
	__parent.transition_to(next_state, damage)

func back_to_battle():
	var next_state = __parent.get_node("Battle")
	__parent.transition_to(next_state)

########################
# State Base Functions #
########################
func enter(entity, dmg):
	animator = entity.get_node("Animator")
	is_flipped = entity.get_flip()
	health = entity.get_health()
	
	if !animator.is_connected("finished",self,"recover"):
		animator.connect("finished",self,"recover")
	
	if !entity.is_connected("internal_damage",self,"combo_damage"):
		entity.connect("internal_damage",self,"combo_damage")
	
	if is_flipped:
		animator.play("damage_flip")
	else:
		animator.play("damage")
	
	health -= dmg
	
	if health <= 0:
		var dead_state = __parent.get_node("Dead")
		__parent.transition_to(dead_state, is_flipped)
		
		health = 0
	
	entity.set_health(health)
	entity.update_enemy_panel()
	pass

func exit(entity):
	if animator.is_connected("finished",self,"recover"):
		animator.disconnect("finished",self,"recover")
	
	if entity.is_connected("internal_damage",self,"combo_damage"):
		entity.disconnect("internal_damage",self,"combo_damage")