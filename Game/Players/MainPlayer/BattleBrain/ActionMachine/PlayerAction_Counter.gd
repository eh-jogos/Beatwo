extends "PlayerAction__Base.gd"

##########################
# class member variables #
##########################

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var battle_brain = __parent.get_node("..") # BattleBrain node

# Internal variables to be used along this state.
## They are declared here as a "class" variable so that different methods can have easy access to them
var counter_damage # amount of damage a counter attack does to an enemy
var targets # enemy entities that should be targeted

#########################
#State Custom Functions #
#########################

# Method to go back to idle once counter animation ends. It's called automatically by the Animation Player
func back_to_idle():
	var next_state = __parent.get_node("Idle")
	__parent.transition_to(next_state)

# Method to deal damage to the target
## Currently it get's called at some point during counter animation and deals damage to each target
## @FUTURE_DATE - Ideally it would happen on contact from a "attack collision shape" from the player into a "hitbox" from the target, maybe through signals?
func hit_counter():
	for enemy in targets:
		enemy.take_damage(counter_damage)

########################
# State Base Functions #
########################

# Method executed everytime the FSM "enters" this state
func enter(entity, counter_target):
	# Makes the player invulnerable
	battle_brain.set_vulnerability(false)
	
	# Initializes damage and targets variables, so they can be used on the "hit_counter()" method
	counter_damage = entity.get_counter_damage()
	targets = counter_target
	
	# Clear the counter_targets and turns off the alarm as the counter has been dealt with.
	battle_brain.clean_counter_target()
	
	# Plays Counter animation
	entity.animator().play("counter1")