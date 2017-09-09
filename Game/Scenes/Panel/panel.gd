extends Control

##########################
# Class Member Variables #
##########################		

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var game = self.get_node("../..") # main game mode node
onready var enemy_name = get_node("EnemyName")
onready var enemy_life = get_node("EnemyLife")
onready var player_name = get_node("Player")
onready var player_life = get_node("PlayerLife")
onready var animator = get_node("PanelAnimator")


#############################
# Custom Method Definitions #
#############################
# Method to update enemy side of the panel
func set_enemy_panel(name, health):
	enemy_name.set_text(name)
	enemy_life.set_text(String(health))
	pass

# Method to update the player side of the panel
func set_player_panel(name, health):
	player_name.set_text(name)
	player_life.set_text(String(health))
	pass

# Method to toggle counter warning animation on the panel
func set_warning_animation(boolean):
	if boolean:
		animator.play("counter_warning")
	else:
		animator.play("normal")


###########################
# Engine Standard Methods #
###########################

# Called every time the node is added to the scene.	
func _ready():
	
	# connects the "enemy_panel" signal to the "set_enemy_panel" method. The arguments for the method are passed by the script that originally emited the signal
	if !game.is_connected("enemy_panel", self, "set_enemy_panel"):
		game.connect("enemy_panel", self, "set_enemy_panel")
	
	# connects the "player_panel" signal to the "set_player_panel" method. The arguments for the method are passed by the script that originally emited the signal
	if !game.is_connected("player_panel", self, "set_player_panel"):
		game.connect("player_panel", self, "set_player_panel")
	
	# connects the "counter_warning" signal to the "set_warning_animation" method. The arguments for the method are passed by the script that originally emited the signal
	if !game.is_connected("counter_warning", self, "set_warning_animation"):
		game.connect("counter_warning", self, "set_warning_animation")
	
	# Playes the default animation for the panel
	animator.play("normal")
