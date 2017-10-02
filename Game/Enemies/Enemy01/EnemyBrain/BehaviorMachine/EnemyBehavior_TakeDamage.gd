extends "EnemyBehavior__Base.gd"

##########################
# class member variables #
##########################

# Internal state variables
var animator # enemy main animation player node
var is_flipped # holds the direction of this entity
var health # holds entity remaining HP

##########################
# State Custom Functions #
##########################

# when damage animation is over, this method is executed to go back to idle
## this is connected through a signal, maybe to keep things in the 
## same standard I should call this method from inside the damage animation?
func recover():
	# playes idle because I still don't have any recover animation
	animator.play("idle")
	back_to_seek()

# Take Damage method, listens to damage signal when 
# this entity receives an attack
func combo_damage(damage):
	var next_state = self
	__parent.transition_to(next_state, damage)

# Method to transition to "Seek" state
func back_to_seek():
	var next_state = __parent.get_node("Seek")
	__parent.transition_to(next_state)

########################
# State Base Functions #
########################

# Method executed everytime the FSM "enters" this state
func enter(entity, dmg):
	# Initializing variables
	animator = entity.animator()
	is_flipped = entity.get_flip()
	health = entity.get_health()
	
	# Connects end of animation signal to recover method
	if !animator.is_connected("finished",self,"recover"):
		animator.connect("finished",self,"recover")
	
	# Connects internal_damage signal to take_damage method
	if !entity.is_connected("internal_damage",self,"combo_damage"):
		entity.connect("internal_damage",self,"combo_damage")
	
	# Checks flip status to choose the correct damage animation
	if is_flipped:
		animator.play("damage_flip")
	else:
		animator.play("damage")
	
	# Subtracts damage taken from health
	health -= dmg
	
	# If health gets to 0 or below, transition to dead state...
	if health <= 0:
		var dead_state = __parent.get_node("Dead")
		__parent.transition_to(dead_state, is_flipped)
		
		# ...and sets health to 0 to prevent negative numbers from appearing
		health = 0
	
	entity.set_health(health)
	entity.update_enemy_panel()
	pass

# Method executed whenever the FSM exits this state
func exit(entity):
	# Connects end of animation signal to recover method
	if animator.is_connected("finished",self,"recover"):
		animator.disconnect("finished",self,"recover")
	
	# Disconnects internal_damage signal to take_damage method
	if entity.is_connected("internal_damage",self,"combo_damage"):
		entity.disconnect("internal_damage",self,"combo_damage")