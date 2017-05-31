extends KinematicBody2D

# class member variables go here, for example:
onready var player = self
onready var radar = self.get_node("EnemyDetection")
onready var animator = self.get_node("Animator")

onready var debug_panels = self.get_node("DebugPanels")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
