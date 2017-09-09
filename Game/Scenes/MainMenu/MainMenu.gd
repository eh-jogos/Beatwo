extends Node2D


##########################
# Class Member Variables #
##########################		

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var animator = self.get_node("HUD/Animator")
onready var new_game_button = self.get_node("HUD/NewGame")
onready var help_button = self.get_node("HUD/Help")
onready var return_button = self.get_node("HUD/HowToPlay/Return")

# Class variables
var packed_scene = load("res://Prototypes/Test01/Teste01.tscn") # Scene to be loaded when game is started


#############################
# Custom Method Definitions #
#############################

# Method to be called when "new_game_button" is pressed
func start_game():
	self.get_tree().change_scene_to(packed_scene)

# Method to be called when "help_button" is pressed
func open_help_menu():
	animator.play("help")
	return_button.grab_focus()

# Method to be called when "return_button" is pressed
func close_help_menu():
	animator.play("main")
	new_game_button.grab_focus()


###########################
# Engine Standard Methods #
###########################

# Called every time the node is added to the scene.	
func _ready():
	# Playes default animation
	animator.play("main")
	
	# Focus on new_game_button
	new_game_button.grab_focus()
	
	# Connects the pressed event of "new_game_button" to the "start_game" method
	if !new_game_button.is_connected("pressed", self, "start_game"):
		new_game_button.connect("pressed",self,"start_game")
	
	# Connects the pressed event of "help_button" to the "open_help_menu" method
	if !help_button.is_connected("pressed", self, "open_help_menu"):
		help_button.connect("pressed",self,"open_help_menu")
	
	# Connects the pressed event of "return_button" to the "close_help_menu" method
	if !return_button.is_connected("pressed", self, "close_help_menu"):
		return_button.connect("pressed",self,"close_help_menu")
