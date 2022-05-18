extends Node2D

onready var children = get_children()
onready var gameplay = $gameplay
onready var titlescreen = $Titlescreen
onready var pause_menu = $pause_menu
onready var control_menu = $control_menu
onready var hud = $hud

func _ready():
	for child in children:
		child.ready()
	#gameplay.enter() remove # when implementing menus
	#pause_menu.exit()
	#titlescreen.enter()
	#titlescreen.menu_camera.make_current()

func _process(_delta):
	pass #print(pause_menu.visible)
