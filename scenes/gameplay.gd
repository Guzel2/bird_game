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
var fly_count = 0
var fly_max = 4
var worm_count = 0
var worm_max = 4

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
	player.mission_complete = false
	player.arrow.visible = false
	
	match phase:
		1:
			level.spawn_nest()
			#level.nest.modulate = Color(1, 1, 1, .7)
			level.nest.ani.animation = 'building'
			level.nest.ani.frame = 0
		2:
			#level.nest.modulate = Color(1, 1, 1, .8)
			level.nest.ani.frame = 1
		3:
			#level.nest.modulate = Color(1, 1, 1, .9)
			level.nest.ani.frame = 2
		4:
			#level.nest.modulate = Color(1, 1, 1, 1)
			level.nest.ani.animation = 'eggs'
		5:
			pass
		6:
			camera.set_weather('rain')
			level.nest.ani.animation = 'full'
			level.nest.ani.playing = true
			for worm in level.worms:
				worm.visible = true

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
	
