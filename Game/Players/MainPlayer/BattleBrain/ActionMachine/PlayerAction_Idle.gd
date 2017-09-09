extends "PlayerAction__Base.gd"

##########################
# class member variables #
##########################

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var battle_brain = __parent.get_node("..") # BattleBrain node


#########################
#State Custom Functions #
#########################

# Player's "take_damage" method, it's repeated on almost every state, it's to be used when the player is receiving damage, and will be executed by the attacking enemy entity.
func take_damage(damage, entity):
	# Checks if the player is vulnerable, and if it is, transitions to TakeDamege
	if battle_brain.get_vulnerability():
		var next_state = __parent.get_node("TakeDamage")
		__parent.transition_to(next_state, damage)


########################
# State Base Functions #
########################

# Method executed everytime the FSM "enters" this state
func enter(entity, variable):
	# Resets focus in case it is still "focused" on something
	if battle_brain.get_focus() == true:
		battle_brain.set_focus(false)
	
	# Connects "internal_damage" signal to the method that transitions the FSM to the TakeDamage state.
	if !entity.is_connected("internal_damage", self, "take_damage"):
		entity.connect("internal_damage", self, "take_damage",[entity])
	
# Method that handles player input
func input(entity, event):
	# On "attack" event, gets the target from BattleBrain and transitions to Attack State
	if event.is_action_pressed("attack"):
		var next_state = __parent.get_node("Attack")
		var attack_target = battle_brain.get_attack_target()
		
		__parent.transition_to(next_state, attack_target)
	
	# On "counter" event, gets the target from BattleBrain and transitions to Counter State
	if event.is_action_pressed("counter") and counter_target.size() > 0:
		var next_state = __parent.get_node("Counter")
		var counter_target = battle_brain.get_counter_target()
		
		__parent.transition_to(next_state, counter_target)

# Method that updates every frame, or every processing interval
func update(entity, delta):
	# Checks wheter animation is playing, and if it isn't, start it
	## I think this works because all animations besides idle are not loops, so whenver the player enters Idle states, the other animations have already stopped playing.
	## This also enables me to transition to idle from another state, before that state's animation is over.
	## @FUTURE_DATE - This will most likely change, as I intend to separate animation commands to it's own FSM.
	if entity.animator() != null and !entity.animator().is_playing():
		entity.animator().play("idle")

# Method executed whenever the FSM exits this state
func exit(entity):
	# Disconnects "internal_damage" signal to the method that transitions the FSM to the TakeDamage state.
	if entity.is_connected("internal_damage", self, "take_damage"):
		entity.disconnect("internal_damage", self, "take_damage")