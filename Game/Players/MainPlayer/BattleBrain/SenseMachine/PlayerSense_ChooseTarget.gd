extends "PlayerSense__Base.gd"

##########################
# Class Member Variables #
##########################

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var battle_brain = __parent.get_node("..") # Gets BattleBrain node

# Internal target variables to be used along this state.
var temp_attack_target = null
var temp_counter_target = []


########################
# State Custom Functions #
########################

# This method is activated when the enemy sends an "attack" signal. It adds the entity that sent the signal to the temp counter target, and updates actual counter targets
func incoming_attack(enemy_node):
	temp_counter_target.push_front(enemy_node)
	battle_brain.set_counter_target(temp_counter_target)
	
#	print(battle_brain.get_counter_target())

# Method to clear out temp_counter_target. Executed automatically when enemy dies.
## It would be better to only remove the wanted entries on the temp_counter_target array. If I figure out how to do it, I shouldchange it here and in BattleBrain
func warning_timed_out():
	temp_counter_target = []

########################
# State Base Functions #
########################

# Method executed everytime the FSM "enters" this state
func enter(entity):
	# Connects signal to execute "warning_timed_out" if a "clear_counter" signal is emited
	if !entity.is_connected("clear_counter", self, "warning_timed_out"):
		entity.connect("clear_counter", self, "warning_timed_out")

# Method that updates every frame, or every processing interval
func update(entity, delta):
	# Gets all "bodies" that are overlapping with the enemy detection area (radar)
	var enemies = entity.radar().get_overlapping_bodies()
	
	# Gets the quantity of enemies
	var enemy_count = enemies.size()
	
	
	if enemy_count > 0:
		# sets an impossibly high initial value
		var smallest_distance = 9999
		
		# loops through the enemies inside the radar
		for enemy in enemies:
			# gets the distance vector by subtracting the player position from the enemy position.
			var distance_vector = entity.get_pos()-enemy.get_pos()
			
			# enemies above or bellow the player seem to have distances much shorter
			# than enemies to the sides, so I'm trying to balance it out to account for
			# perspective by giving the "y" position some weight
			distance_vector = Vector2(distance_vector.x, distance_vector.y*5)
			
			# Calculates the distance using pitagoras
			var distance = sqrt((distance_vector.x*distance_vector.x)+(distance_vector.y*distance_vector.y))
			
			# The reason the initial "smallest_distance" is high is to make sure this condition won't fail for all enemies in the radar
			## This will be checked and executed for every enemy in the loop, once the loop ends, the value of temp_attack_target will be the closest enemy
			if distance < smallest_distance:
				smallest_distance = distance
				temp_attack_target = enemy
			
			# Make sure every enemy is connected to "incoming_attack" method, 
			# so the player can "sense" attacks in order to counter
			if !enemy.is_connected("attack_player", self, "incoming_attack"):
				enemy.connect("attack_player", self, "incoming_attack",[enemy])
			
			# Make sure every enemy death is connected to "set_attack_target" 
			# method on the battle brain, so the "attack target" can be 
			# reseted as soon as the enemy dies, preventing errors of 
			# trying to attack a removed node
			if !enemy.is_connected("enemy_dead", battle_brain, "set_attack_target"):
				enemy.connect("enemy_dead", battle_brain, "set_attack_target",[null])
			
			# Make sure every enemy death is connected to "clean_counter_target" 
			# method, to reset temp_counter_target
			if !enemy.is_connected("enemy_dead", battle_brain, "clean_counter_target"):
				enemy.connect("enemy_dead", battle_brain, "clean_counter_target")
		
		# Once the loop is over, update real attack_target
		battle_brain.set_attack_target(temp_attack_target)
	
	# If enemy_count IS NOT greater than 0, goes back to "DetectEnemy" state
	else: 
		var next_state = __parent.get_node("DetectEnemy")
		__parent.transition_to(next_state)
		
# Method executed whenever the FSM exits this state
func exit(entity):
	# Resets both "temp_" target variables
	temp_attack_target = null 
	temp_counter_target = []
	
	# Resets both "targets" on the BattleBrain
	battle_brain.set_attack_target(null)
	battle_brain.clean_counter_target()
	
	# Disconnects signal that monitors whether th counter warning has timed out
	if entity.is_connected("clear_counter", self, "warning_timed_out"):
		entity.disconnect("clear_counter", self, "warning_timed_out")