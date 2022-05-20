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

func _ready():
	exit()

func ready():
	for child in children:
		child.ready()
	#pause_menu = parent.pause_menu
	#titlescreen = parent.titlescreen
	#hud = parent.hud
	#hud.partner_hud.enter()

func exit():
	self.visible = false
	set_process(false)
	for child in children:
		child.set_process(false)

func enter():
	#update_hud()
	#update_count()
	#in_titlescreen = false #muss auf false gesetzt werden damit es visible wird
	visible = true
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
	#update_hud()
	
	match phase:
		1:
			level.spawn_nest()
			level.nest.ani.animation = 'building'
			level.nest.ani.frame = 0
		2:
			camera.set_weather('clear', 0)
			level.nest.ani.frame = 1
		3:
			level.nest.ani.frame = 2
		4:
			play_cutscene('laying_egg')
			level.nest.ani.animation = 'eggs'
		5:
			set_autumn()
		6:
			camera.set_weather('rain', 45)
			level.nest.ani.animation = 'full'
			level.nest.ani.playing = true
			for worm in level.worms:
				worm.visible = true
		7:
			play_cutscene('feeding_children')
		8:
			play_cutscene('flying_away')
			level.spawn_chicks()

func play_cutscene(animation):
	camera.play_cutscene(animation)

func set_autumn():
	for tree in level.trees:
		tree.frame = 1
		tree.tree_log.frame = 1
		tree.tree_branches.frame = 1
		tree.leaves.animation = tree.leaves.animation + '_autumn'
	player.music_summer.playing = false
	player.music_autumn.playing = true

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		exit()
		set_process(false)
		for child in children:
			child.set_process(false)
		self.visible = true
		pause_menu.enter()
		pause_menu.rect_scale = player.scale
		pause_menu.rect_position = player.position
		player.animation.playing = false

func update_hud():
	match phase:
		0:
			hud.partner_hud.animation = 'partner'
			hud.partner_hud.send_message()
			update_count()
			print("partner_icon sichtbar")
			#hud.count.text = space + str(partner_count) + "/" + str(partner_max)
		1, 2, 3:
			hud.partner_hud.animation = 'branch'
			hud.partner_hud.send_message()
			update_count()
			#hud.count.text = space + str(branch_count) + "/" + str(branch_max)
		4, 5:
			hud.partner_hud.animation = 'fly'
			hud.partner_hud.send_message()
			update_count()
			#hud.count.text = space + str(fly_count) + "/" + str(fly_max)
		6, 7:
			hud.partner_hud.animation = 'worm'
			hud.partner_hud.send_message()
			update_count()
			#hud.count.text = space + str(worm_count) + "/" + str(worm_max)

func update_count():
	match phase:
		0:
			hud.count.text = space + str(partner_count) + "/" + str(partner_max)
			
		1, 2, 3:
			hud.count.text = space + str(branch_count) + "/" + str(branch_max)
			if(branch_count == branch_max):
				hud.partner_hud.send_message()
		4, 5:
			hud.count.text = space + str(fly_count) + "/" + str(fly_max)
			if(fly_count == fly_max):
				parent.hud.partner_hud.send_message()
		6, 7:
			hud.count.text = space + str(worm_count) + "/" + str(worm_max)
			if(worm_count == worm_max):
				parent.hud.partner_hud.send_message()
