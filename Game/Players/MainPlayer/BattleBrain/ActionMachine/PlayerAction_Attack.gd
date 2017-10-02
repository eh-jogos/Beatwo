extends "PlayerAction__Base.gd"

##########################
# class member variables #
##########################

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var battle_brain = __parent.get_node("..") # BattleBrain node
onready var radar # declares variable to hold the enemy radar down bellow

# This variable is used to control to which state the FSM will go next, after the attack animation finishes
## The possible states are Idle or Attack (re-enters itself when comboing) 
## Besides these ones above, it can also transition to TakeDamage or Counter, but that is handled by a separate methods, since they interrupt the attack, and shouldn't wait until the end of attack animation to transition.
onready var next_action = __parent.get_node("Idle") 

# Internal target variables to be used along this state.
# This is needed because there are times where the BattleBrain will have a more updated target, but the attack will be locked on the initial target
var target = null
var counter_target = []

#########################
#State Custom Functions #
#########################

# Method to deal damage to the target
## Currently it get's called at some point during attack animation and deals damage to the target
## @FUTURE_DATE - Ideally it would happen on contact from a "attack collision shape" from the player into a "hitbox" from the target, maybe through signals?
## The node_path parameter is what I could bring from activating this method from the animation player. This will probably change when it's working by signal
func hit_target(node_path):
	# Get's the hit_damage from the player
	var hit_damage = get_node(node_path).get_hit_damage() 
	
	# If target is not null, executes "take_damage" method inside the target
	if target != null:
		#print("hit")
		target.take_damage(hit_damage)

# Player's "take_damage" method, it's repeated on almost every state, it's to be used when the player is receiving damage, and will be executed by the attacking enemy entity.
func take_damage(damage, entity):
	# Checks if the player is vulnerable, and if it is, transitions to TakeDamege
	if battle_brain.get_vulnerability():
		var next_state = __parent.get_node("TakeDamage")
		__parent.transition_to(next_state, damage)

# Method to choose to which state the FSM should go, automatically called at the end of attack animation
func choose_action(node_path):
	var entity = self.get_node(node_path) # get's player node from path passed through the animation player
	target = battle_brain.get_attack_target() # get's the current attack target to pass as a parameter
	__parent.transition_to(next_action, target) # transitions to whatever node is on the "next_action" variable

	
########################
# State Base Functions #
########################

# Method executed everytime the FSM "enters" this state
func enter(entity, attack_target):
	# Checks whether "attack_target" is null, as it will only update internal "target" if it needs to.
	if attack_target != null:
		battle_brain.set_focus(true) # Sets "focus" to true, so that the player can't change attack targets unless it stops attacking or the target is defeated
		radar = entity.radar() # Gets enemy radar from player node
		var enemies = radar.get_overlapping_bodies() # get's all enemy entities on the radar...
		
		# ...loops through them...
		for enemy in enemies:
			# ... and checks whether the "attack_target" is whithin them, before assigning it to internal "target"
			## This is done to prevent errors when assigning a target to a enemy that has left the radar area, or already died and was removed from scene.
			if enemy == attack_target:
				target = attack_target
	
	# Playes standard attack animation
	#@FUTURE_DATE - How will you deal with playing different attack animations? Either for combos, or a random attack system, or a intelligent attack system, you will have to find a way to deal with it
	entity.animator().play("attack1")
	
	# Connects "internal_damage" signal to the method that transitions the FSM to the TakeDamage state.
	if !entity.is_connected("internal_damage", self, "take_damage"):
		entity.connect("internal_damage", self, "take_damage",[entity])

# Method that handles player input
func input(entity, event):
	# Changes "next_action" to "Attack" in case the player makes combos
	## @FUTURE_DATE - This method might need aditional information once combos start to get more complex
	if event.is_action_pressed("attack"):
		next_action = __parent.get_node("Attack")
	
	# If input event is counter, and there are counter targets, interrupt attack and immediatly transitions to Counter
	if event.is_action_pressed("counter") and counter_target.size() > 0:
		var next_state = __parent.get_node("Counter")
		__parent.transition_to(next_state, counter_target)

# Method that updates every frame, or every processing interval
func update(entity, delta):
	# updates counter targets
	counter_target = battle_brain.get_counter_target()

# Method executed whenever the FSM exits this state
func exit(entity):
	# Disconnects "internal_damage" signal to the method that transitions the FSM to the TakeDamage state.
	## The reason to keep connecting and disconnecting the damage dealing methods, is so that when the signal is fired it doesn't fire multiple the transition multiple times
	## and so that I can control if the transition to TakeDamage state is possible from within each state. To have a clearer view of this, you can check the Player's ActionMachine Diagram on github
	if entity.is_connected("internal_damage", self, "take_damage"):
		entity.disconnect("internal_damage", self, "take_damage")
	
	# resets internal targets
	target = null
	counter_target = []
	
	# defaults "next_action" variable to it's default value 
	next_action = __parent.get_node("Idle")