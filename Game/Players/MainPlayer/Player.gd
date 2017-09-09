extends KinematicBody2D

##########################
# class member variables #
##########################

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var animator = self.get_node("Animator") # Animation Player
onready var radar = self.get_node("EnemyDetection") # Area2d for detecting enemies
onready var game = self.get_node("../..") # Game World Root Node
onready var player_name = self.get_name() # Get Player node's name when the node is ready.

# Player's Internal Variables and Stats
export var health = 10 # Player's Life
export var hit_damage = 5 # Damage of player's Attacks
export var counter_damage = 2 # Damage of Counter's Attacks

# Player's internal signals
signal internal_damage # Signal to deal with damage taken
signal clear_counter # Signal to clear counter targets???

#############################
# Custom Method Definitions #
#############################
# function for accessing the animator
func animator():
	return animator

# function for accesing the Area2d that detects enemies
func radar():
	return radar

# Returns health value to whoever is asking for it
func get_health():
	return health
	
# Sets health value and updates the main panel(s)
func set_health(hp):
	health = hp
	update_player_panel(player_name, health)

# Returns ammount of damage to be dealt by an attack
func get_hit_damage():
	return hit_damage

# Sets ammount of damage to be dealt by an attack
func set_hit_damage(dmg):
	hit_damage = dmg

# Returns ammount of damage to be dealt by an attack
func get_counter_damage():
	return counter_damage

# Sets ammount of damage to be dealt by an attack
func set_counter_damage(dmg):
	counter_damage = dmg

# This function is called by the enemy entity, when it lands a hit on the player.
## It serves to trigger the 'internal_damage' signal, with the ammount of damage that is due
## The signal will be 'heard' or not by the current ActionState the player's is in, and will be dealt with accordingly
func take_damage(dmg):
	self.emit_signal("internal_damage",dmg)

# Update the main panel(s) on the enemy side
func update_enemy_panel(enemy_name, enemy_health):
	game.emit_signal("enemy_panel", enemy_name, enemy_health)

# Update the main panel(s) on the player side
func update_player_panel(name, health):
	game.emit_signal("player_panel", name, health)

# Toggles Panel's Counter Warning animation On or Off 
func counter_warning(boolean):
	game.emit_signal("counter_warning",boolean)
	
	# Should this function always emit the "clear_counter" signal?? Shouldn't it emit this signal only when toggling Off???
	self.emit_signal("clear_counter")

###########################
# Engine Standard Methods #
###########################

# Called every time the node is added to the scene.
func _ready():
	set_process(true)

# Called every time a frame is drawn, not necessarily at regular intervals
## delta is ammount of time elapsed since last time it executed.
func _process(delta):
	update_player_panel(player_name, health)
