extends Node2D

onready var parent = get_parent()
onready var children = get_children()
onready var player = $player
onready var camera = $camera
onready var titlescreen
onready var pause_menu
onready var in_titlescreen = false
onready var level = $level

var phase = 0

var partner_count = 0
var partner_max = 1
var branch_count = 0
var branch_max = 5
var worm_count = 0
var worm_max = 5

func ready():
	for child in children:
		child.ready()
	pause_menu = parent.pause_menu
	titlescreen = parent.titlescreen

func exit():
	self.visible = false
	set_process(false)
	for child in children:
		child.set_process(false)

func enter():
	in_titlescreen = false #muss auf false gesetzt werden damit es visible wird
	self.visible = true
	set_process(true)
	for child in children:
		child.set_process(true)
	camera.make_current()
	player.animation.playing = true

func check_titlescreen(): #neue funktion um zu überprüfen ob sich das game im Menü befinden
	if in_titlescreen == true: 
		self.visible = false #macht gameplay unsichtbar (auch den vogel) wenn im titelscreen

func next_phase():
	phase += 1
	print('next_phase')

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		exit()
		self.visible = true
		pause_menu.enter()
		pause_menu.rect_scale = player.scale
		pause_menu.rect_position = player.position
		player.animation.playing = false
