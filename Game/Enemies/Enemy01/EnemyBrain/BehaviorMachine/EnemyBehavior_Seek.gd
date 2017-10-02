extends "EnemyBehavior__Base.gd"

##########################
# class member variables #
##########################

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var enemy_brain = __parent.get_node("..") # EnemyBrain node

# Internal state variables
var target_pos # player position
var distance # distance between player and enemy
var direction # direction of movement towards player
var target_range = 45.0 # range in wich attacking the target becomes possible

# Constant for enemy movement speed
const MAX_SPEED = 80 


##########################
# State Custom Functions #
##########################

# Take Damage method, listens to damage signal when 
# this entity receives an attack and transitions to TakeDamage state
func take_damage(damage):
	var next_state = __parent.get_node("TakeDamage")
	__parent.transition_to(next_state, damage)

# Method to transition to Idle state
func go_idle():
	var next_state = __parent.get_node("Idle")
	__parent.transition_to(next_state)

# Method to transition to Win state
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
	
	# Initializes player's position
	target_pos = enemy_brain.get_player_pos()
	
	#calculates distance between entity and player
	distance = entity.get_pos().distance_to(target_pos)
	
	# If distance is less than entities attack range...
	if distance < target_range:
		go_idle() # transition to idle
	
	# Plays idle animation because right now I don't have a "seeking" or 
	# "walking" animation
	entity.animator().play("idle")
	
	# Find the direction by subtracting this entity's postion from the player's
	# position, and then normalize it.
	## Should I use dot product here?
	direction = target_pos - entity.get_pos()
	direction = direction.normalized()
	pass

# Method that updates every frame, or every processing interval
func update(entity, delta):
	# gets player health
	var player_health = enemy_brain.get_player().get_health()
	# if player is dead, celebrate
	if player_health <= 0:
		celebrate()
	
	# defines how much the entity will move towards the target on this frame
	var motion = direction * MAX_SPEED * delta
	
	# calculates distance from target to this entity
	distance = entity.get_pos().distance_to(target_pos)
	
	# If distance is less than a random range between closest and farthest
	# possible ranges for atacking, transitions to idle
	# if not, continue moving towards the target
	## I should probably make this rand_range a variable defined on enter
	## instead of redefining it everyframe here on update
	if distance < floor(rand_range(32.0,target_range)):
		go_idle()
	else:
		entity.move(motion)

# Method executed whenever the FSM exits this state
func exit(entity):
	# Diconnects internal_damage signal to take_damage method
	if entity.is_connected("internal_damage",self,"take_damage"):
		entity.disconnect("internal_damage",self,"take_damage")