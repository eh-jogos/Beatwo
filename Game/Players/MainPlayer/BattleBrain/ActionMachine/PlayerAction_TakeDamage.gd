extends "PlayerAction__Base.gd"

##########################
# class member variables #
##########################

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var battle_brain = __parent.get_node("..") # Battle Brain node

#########################
#State Custom Functions #
#########################

# Method called by "internal_damage" signal, when the player character receives damage while in "take_damage" animation
func combo_damage(damage):
	if battle_brain.get_vulnerability():
		var next_state = self
		__parent.transition_to(next_state, damage)

# Method that executes automatically when damage animation ends. 
## It sets vulnerability to false before going back to idle to give the player some invincibility frames and a little room to breath
func back_to_idle():
	battle_brain.set_vulnerability(false) 
	
	var next_state = __parent.get_node("Idle")
	__parent.transition_to(next_state)


########################
# State Base Functions #
########################

# Method executed everytime the FSM "enters" this state
func enter(entity, dmg):
	var health = entity.get_health() # get's player health
	
	battle_brain.clean_counter_target() # resets counter targets
	
	# Connects  "combo_damage" method to be called if "internal_damage" siganl is emited
	if !entity.is_connected("internal_damage",self,"combo_damage"):
		entity.connect("internal_damage",self,"combo_damage")
	
	entity.animator().play("take_damage") # plays damage animation
	
	health -= dmg # subtracts damage from health
	
	# If health is less than or equal to 0, transition to "Dead" state, else, update the player's health
	if health <= 0:
		var next_state = __parent.get_node("Dead")
		__parent.transition_to(next_state)
	else:
		entity.set_health(health)

# Method that handles player input
func input(entity, event):
	# there should be code to handle counter input and transtition to "Counter" state here
	pass
	
# Method that updates every frame, or every processing interval
func update(entity, delta):
	# updates counter targets
	counter_target = battle_brain.get_counter_target()

# Method executed whenever the FSM exits this state
func exit(entity):
	# Disconnects "internal_damage" signal to the method that transitions the FSM to the TakeDamage state.
	if entity.is_connected("internal_damage",self,"combo_damage"):
		entity.disconnect("internal_damage",self,"combo_damage")
