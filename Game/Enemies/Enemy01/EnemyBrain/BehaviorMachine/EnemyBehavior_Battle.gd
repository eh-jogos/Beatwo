extends "EnemyBehavior__Base.gd"

##########################
# class member variables #
##########################

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var enemy_brain = __parent.get_node("..")

var target
var target_pos
var animator
var damage

var timer

##########################
# State Custom Functions #
##########################
func take_damage(damage, player):
	var next_state = __parent.get_node("TakeDamage")
	
	target.counter_warning(false)
	__parent.transition_to(next_state, damage)

func idle():
	var next_state = __parent.get_node("Idle")
	__parent.transition_to(next_state, damage)

func attack(entity):

	pass

func deal_damage():
	target.take_damage(damage)

########################
# State Base Functions #
########################
func enter(entity, variable):
	if !entity.is_connected("internal_damage",self,"take_damage"):
		entity.connect("internal_damage",self,"take_damage",[target])
	
	target = enemy_brain.get_player()
	damage = entity.get_hit_damage()
	animator = entity.get_node("Animator")
	
	entity.emit_signal("attack_player")
	animator.play("attack")

func update(entity, delta):
	pass

func exit(entity):
	if entity.is_connected("internal_damage",self,"take_damage"):
		entity.disconnect("internal_damage",self,"take_damage")
