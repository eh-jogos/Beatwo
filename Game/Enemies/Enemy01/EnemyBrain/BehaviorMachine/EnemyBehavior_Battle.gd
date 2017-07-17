extends "BaseBehavior.gd"

##########################
# class member variables #
##########################
onready var enemy_brain = __parent.get_node("..")

var target
var target_pos
var animator
var damage

var timer

##########################
# State Custom Functions #
##########################
func idle_timer():
	timer.set_wait_time(rand_range(2.0,5.0))
	timer.start()

func take_damage(damage):
	var next_state = __parent.get_node("TakeDamage")
	__parent.transition_to(next_state, damage)

func idle():
	animator.play("idle")
	idle_timer()

func attack():
	#For now this line is here because if I try to put it on enter()
	#it executes too soon, before the __player variable in enemy_brain is ready
	#Once you have a proper Spawn and Seek states, move this back to enter()
	target = enemy_brain.get_player()
	
	target.take_damage(damage)
	
	idle()
	pass

########################
# State Base Functions #
########################
func enter(entity, variable):
	if !entity.is_connected("internal_damage",self,"take_damage"):
		entity.connect("internal_damage",self,"take_damage")
	
	animator = entity.get_node("Animator")
	damage = entity.get_hit_damage()
	
	timer = Timer.new()
	timer.set_one_shot(true)
	self.add_child(timer)
	
	if !timer.is_connected("timeout",self,"attack"):
		timer.connect("timeout",self,"attack")
	
	idle()

func update(entity, delta):
	pass

func exit(entity):
	if entity.is_connected("internal_damage",self,"take_damage"):
		entity.disconnect("internal_damage",self,"take_damage")
	
	if timer.is_connected("timeout",self,"attack"):
		timer.disconnect("timeout",self,"attack")
	
	timer.queue_free()