extends "EnemyBehavior__Base.gd"

##########################
# class member variables #
##########################

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var enemy_brain = __parent.get_node("..") # EnemyBrain Node

# Internal state variables
var target # will hold the "player" node
var damage # will hold the damage enemy attacks deal to the player

##########################
# State Custom Functions #
##########################
# Take Damage method, listens to damage signal when this entity receives an attack
## It simply deactivates any counter warning on the player entity and transitions to take damage.
func take_damage(damage, player):
	var next_state = __parent.get_node("TakeDamage")
	
	target.counter_warning(false)
	__parent.transition_to(next_state, damage)

# Method called at the end of the "attack" animation to transition back to idle
func idle():
	var next_state = __parent.get_node("Idle")
	__parent.transition_to(next_state, damage)

# Method called in the middle of the "attack" animation, to make the player take damage
func deal_damage():
	target.take_damage(damage)

########################
# State Base Functions #
########################

# Method executed everytime the FSM "enters" this state
func enter(entity, variable):
	# Connects internal_damage signal to take_damage method
	if !entity.is_connected("internal_damage",self,"take_damage"):
		entity.connect("internal_damage",self,"take_damage",[target])
	
	# Initializes internal variables
	target = enemy_brain.get_player()
	damage = entity.get_hit_damage()
	
	# Emits signal to generate counter warning
	entity.emit_signal("attack_player")
	
	# Start attack animation
	entity.animator().play("attack")

# Method that updates every frame, or every processing interval
func update(entity, delta):
	pass

# Method executed whenever the FSM exits this state
func exit(entity):
	# Disconnects internal_damage signal to take_damage method
	if entity.is_connected("internal_damage",self,"take_damage"):
		entity.disconnect("internal_damage",self,"take_damage")
