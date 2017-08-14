extends "PlayerSense__Base.gd"

##########################
# Class Member Variables #
##########################
onready var battle_brain = __parent.get_node("..")
var radar
var temp_attack_target = null
var temp_counter_target = []

########################
# State Base Functions #
########################
func back_to_detect(entity):
	temp_attack_target = null
	temp_counter_target = []
	battle_brain.set_attack_target(null)
	battle_brain.clean_counter_target()
	
	if entity.is_connected("clear_counter", self, "warning_timed_out"):
		entity.disconnect("clear_counter", self, "warning_timed_out")
	
	var next_state = __parent.get_node("DetectEnemy")
	__parent.transition_to(next_state)

func incoming_attack(enemy_node):
	temp_counter_target.push_front(enemy_node)
	battle_brain.set_counter_target(temp_counter_target)
	
#	print(battle_brain.get_counter_target())
	pass

func warning_timed_out():
	temp_counter_target = []

########################
# State Base Functions #
########################
func enter(entity):
	radar = entity.radar()
	if !entity.is_connected("clear_counter", self, "warning_timed_out"):
		entity.connect("clear_counter", self, "warning_timed_out")

func update(entity, delta):
	var enemies = entity.radar().get_overlapping_bodies()
	var enemy_count = enemies.size()
	
	
	if enemy_count > 0:
		var smallest_distance = 9999
		
		for enemy in enemies:
			var distance_vector = entity.get_pos()-enemy.get_pos()
			
			# enemies above or bellow the player seem to have distances much shorter
			# than enemies to the sides, so I'm trying to balance it out to account for
			# perspective by giving the "y" position some weight
			distance_vector = Vector2(distance_vector.x, distance_vector.y*5)
			
			var distance = sqrt((distance_vector.x*distance_vector.x)+(distance_vector.y*distance_vector.y))
			
			if distance < smallest_distance:
				smallest_distance = distance
				temp_attack_target = enemy
			
			if !enemy.is_connected("attack_player", self, "incoming_attack"):
				enemy.connect("attack_player", self, "incoming_attack",[enemy])
			
			if !enemy.is_connected("enemy_dead", battle_brain, "set_attack_target"):
				enemy.connect("enemy_dead", battle_brain, "set_attack_target",[null])
			
			if !enemy.is_connected("enemy_dead", battle_brain, "clean_counter_target"):
				enemy.connect("enemy_dead", battle_brain, "clean_counter_target")
		
		battle_brain.set_attack_target(temp_attack_target)
	else:
		back_to_detect(entity)
	
#	var name
#	if battle_brain.get_attack_target() != null:
#		name = battle_brain.get_attack_target().get_name()
#	else:
#		name = "null"
	
#	print("Attack target: %s" % [name])
#	print("Counter target: %s" % [battle_brain.get_counter_target().size()])
