extends "EnemyBehavior__Base.gd"

##########################
# class member variables #
##########################

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var enemy_brain = __parent.get_node("..")

var target_pos
var distance
var direction
var target_range = 45.0

const MAX_SPEED = 80


##########################
# State Custom Functions #
##########################
func take_damage(damage):
	var next_state = __parent.get_node("TakeDamage")
	__parent.transition_to(next_state, damage)

func go_idle():
	var next_state = __parent.get_node("Idle")
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
	
	target_pos = enemy_brain.get_player_pos()
	
	distance = entity.get_pos().distance_to(target_pos)
	if distance < target_range:
		go_idle()
	
	entity.animator().play("idle")
	
	direction = target_pos - entity.get_pos()
	direction = direction.normalized()
	pass

func update(entity, delta):
	var player_health = enemy_brain.get_player().get_health()
	if player_health <= 0:
		celebrate()
	
	var motion = direction * MAX_SPEED * delta
	distance = entity.get_pos().distance_to(target_pos)
	
	if distance < floor(rand_range(32.0,target_range)):
		go_idle()
	else:
		entity.move(motion)

func exit(entity):
	if entity.is_connected("internal_damage",self,"take_damage"):
		entity.disconnect("internal_damage",self,"take_damage")