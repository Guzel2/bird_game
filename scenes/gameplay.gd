extends Node2D

onready var parent = get_parent()
onready var children = get_children()
onready var player = $player
onready var camera = $camera
onready var titlescreen
onready var pause_menu
onready var in_titlescreen = false
onready var level = $level
onready var hud

var phase = 0

var partner_count = 0
var partner_max = 1
var branch_count = 0
var branch_max = 5
var worm_count = 0
var worm_max = 5

var space = '          '

func ready():
	for child in children:
		child.ready()
	pause_menu = parent.pause_menu
	titlescreen = parent.titlescreen
	hud = parent.hud

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
	
	match phase:
		1:
			level.spawn_nest()
			level.nest.modulate = Color(1, 1, 1, .55)
		2:
			level.nest.modulate = Color(1, 1, 1, .7)
		3:
			level.nest.modulate = Color(1, 1, 1, .85)
		4:
			level.nest.modulate = Color(1, 1, 1, 1)

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		exit()
		self.visible = true
		pause_menu.enter()
		pause_menu.rect_scale = player.scale
		pause_menu.rect_position = player.position
		player.animation.playing = false
	

func update_hud():
	match phase:
		0:
			hud.count.text = space + str(partner_count) + "/" + str(partner_max)
		1:
			hud.count.text = space + str(branch_count) + "/" + str(branch_max)
		2:
			hud.count.text = space + str(worm_count) + "/" + str(worm_max)
	
