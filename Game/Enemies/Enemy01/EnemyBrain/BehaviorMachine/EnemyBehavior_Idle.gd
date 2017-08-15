extends "EnemyBehavior__Base.gd"

##########################
# class member variables #
##########################
onready var enemy_brain = __parent.get_node("..")

var animator
var timer

##########################
# State Custom Functions #
##########################
func idle_timer():
	timer.set_wait_time(rand_range(0.5,2.5))
	timer.start()

func take_damage(damage):
	var next_state = __parent.get_node("TakeDamage")
	__parent.transition_to(next_state, damage)

func attack(entity):
	var next_state = __parent.get_node("Battle")
	__parent.transition_to(next_state)

func celebrate():
	var next_state = __parent.get_node("Win")
	__parent.transition_to(next_state)


########################
# State Base Functions #
########################
func enter(entity, variable):
	if !entity.is_connected("internal_damage",self,"take_damage"):
		entity.connect("internal_damage",self,"take_damage")

	animator = entity.get_node("Animator")
	
	animator.play("idle")
	
	timer = Timer.new()
	timer.set_one_shot(true)
	self.add_child(timer)
	
	if !timer.is_connected("timeout",self,"attack"):
		timer.connect("timeout",self,"attack",[entity])
	
	idle_timer()

func update(entity, delta):
	var player_health = enemy_brain.get_player().get_health()
	if player_health <= 0:
		celebrate()
	pass

func exit(entity):
	timer.stop()
	
	if entity.is_connected("internal_damage",self,"take_damage"):
		entity.disconnect("internal_damage",self,"take_damage")
	
	if timer.is_connected("timeout",self,"attack"):
		timer.disconnect("timeout",self,"attack")
	
	timer.queue_free()