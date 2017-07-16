extends "BaseAction.gd"

##########################
# class member variables #
##########################
onready var battle_brain = __parent.get_node("..")
onready var next_action = __parent.get_node("Idle")
onready var radar

var target = null
var counter_target = []

#########################
#State Custom Functions #
#########################

# get's called at some point during attack animation
func hit_target(node_path):
	var hit_damage = get_node(node_path).get_hit_damage()
	if target != null:
		#print("hit")
		target.take_damage(hit_damage)

func take_damage(damage, entity):
	if battle_brain.get_vulnerability():
		if entity.is_connected("internal_damage", self, "take_damage"):
			entity.disconnect("internal_damage", self, "take_damag")
		var next_state = __parent.get_node("TakeDamage")
		__parent.transition_to(next_state, damage)

# get's called at the end of attack animation
func choose_action(node_path):
	var entity = self.get_node(node_path)
	target = battle_brain.get_attack_target()
	change_state(next_action, target, entity)


func change_state(state, variable, entity):
	exit(entity)
	__parent.transition_to(state, variable)


########################
# State Base Functions #
########################
func enter(entity, attack_target):
	battle_brain.set_focus(true)
	radar = entity.radar()
	var enemies = radar.get_overlapping_bodies()
	
	for enemy in enemies:
		if enemy == attack_target:
			target = attack_target
	
	if target == null:
		battle_brain.set_focus(false)
	
	entity.animator().play("attack1")
	
	if !entity.is_connected("internal_damage", self, "take_damage"):
		entity.connect("internal_damage", self, "take_damage",[entity])

func input(entity, event):
	if event.is_action_pressed("attack"):
		next_action = __parent.get_node("Attack")
	
	if event.is_action_pressed("counter") and counter_target.size() > 0:
		var next_state = __parent.get_node("Counter")
		change_state(next_state, counter_target, entity)

func update(entity, delta):
	counter_target = battle_brain.get_counter_target()

func exit(entity):
	if entity.is_connected("internal_damage", self, "take_damage"):
		entity.disconnect("internal_damage", self, "take_damage")
	target = null
	counter_target = []
	next_action = __parent.get_node("Idle")
	pass