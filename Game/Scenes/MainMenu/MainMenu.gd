extends Node2D

var packed_scene = load("res://Prototypes/Test01/Teste01.tscn")

onready var animator = self.get_node("HUD/Animator")
onready var new_game_button = self.get_node("HUD/NewGame")
onready var help_button = self.get_node("HUD/Help")
onready var return_button = self.get_node("HUD/HowToPlay/Return")


func start_game():
	self.get_tree().change_scene_to(packed_scene)

func open_help_menu():
	animator.play("help")
	return_button.grab_focus()

func close_help_menu():
	animator.play("main")
	new_game_button.grab_focus()

func _ready():
	animator.play("main")
	new_game_button.grab_focus()
	
	if !new_game_button.is_connected("pressed", self, "start_game"):
		new_game_button.connect("pressed",self,"start_game")
	
	if !help_button.is_connected("pressed", self, "open_help_menu"):
		help_button.connect("pressed",self,"open_help_menu")
	
	if !return_button.is_connected("pressed", self, "close_help_menu"):
		return_button.connect("pressed",self,"close_help_menu")
	pass
