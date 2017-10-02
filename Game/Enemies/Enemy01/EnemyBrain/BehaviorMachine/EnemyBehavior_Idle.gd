extends "EnemyBehavior__Base.gd"

##########################
# class member variables #
##########################

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var enemy_brain = __parent.get_node("..") # EnemyBrain node

# Internal state variables
var timer # countdown timer used to transtition to Battle state

##########################
# State Custom Functions #
##########################

# sets a random time for the timer and start it
func idle_timer():
	timer.set_wait_time(rand_range(0.5,2.5))
	timer.start()

# Take Damage method, listens to damage signal when 
# this entity receives an attack
func take_damage(damage):
	var next_state = __parent.get_node("TakeDamage")
	__parent.transition_to(next_state, damage)

# Method to transition to the Battle state
func attack(entity):
	var next_state = __parent.get_node("Battle")
	__parent.transition_to(next_state)

# Method to transition to the Win state
func celebrate():
	var next_state = __parent.get_node("Win")
	__parent.transition_to(next_state)


########################
# State Base Functions #
########################

# Method executed everytime the FSM "enters" this state
func enter(entity, variable):
	# Connects internal_damage signal to take_damage method
	if !entity.is_connected("internal_damage",self,"take_damage"):
		entity.connect("internal_damage",self,"take_damage")

	# start idle animation
	entity.animator().play("idle")
	
	timer = Timer.new() # creates a new timer
	timer.set_one_shot(true) # makes it run only once
	self.add_child(timer) # add it to the scenetree
	
	# Connects the new timer timeout signal to the attack method
	if !timer.is_connected("timeout",self,"attack"):
		timer.connect("timeout",self,"attack",[entity])
	
	idle_timer()

# Method that updates every frame, or every processing interval
func update(entity, delta):
	# gets player health
	var player_health = enemy_brain.get_player().get_health()
	# if player is dead, celebrate
	if player_health <= 0:
		celebrate()
	pass

# Method executed whenever the FSM exits this state
func exit(entity):
	timer.stop() # stops timer
	timer.queue_free() # delete the instance
	
	# Disconnects internal_damage signal to take_damage method
	if entity.is_connected("internal_damage",self,"take_damage"):
		entity.disconnect("internal_damage",self,"take_damage")
	
	# Disconnects the new timer timeout signal to the attack method
	if timer.is_connected("timeout",self,"attack"):
		timer.disconnect("timeout",self,"attack")
	