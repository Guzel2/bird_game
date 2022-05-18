extends Node2D

onready var parent = get_parent()
onready var tilemap = $tilemap
var player

var cant_spawn_here = []

var tree_noise = OpenSimplexNoise.new()
var tree_step_size = 250
var tree_threshhold = .725
var tree_range = 20000
var trees = []

var dirt_threshhold = -.85

var branch_noise = OpenSimplexNoise.new()
var branch_range = 400
var branch_step = 100
var branch_threshhold = -.75
var branches = []

var cloud_noise = OpenSimplexNoise.new()
var cloud_step = 400
var cloud_threshhold = -.75
var clouds_1 = []

var cloud_2_noise = OpenSimplexNoise.new()
var cloud_2_step = 800
var cloud_2_threshhold = -.745
var clouds_2 = []

var worm_range = 600
var worm_step = 100
var worm_threshhold = -.725
var worms = []

var partner_threshhold = -.82
var partners = []

var deco_threshhold = -.78

func ready():
	randomize()
	player = parent.player
	
	#noise
	tree_noise.seed = randi()
	tree_noise.octaves = 1
	tree_noise.period = 75.0
	tree_noise.persistence = 0.5
	
	branch_noise.seed = randi()
	branch_noise.octaves = 1
	branch_noise.period = 10.0
	branch_noise.persistence = 0.2
	
	cloud_noise.seed = randi()
	cloud_noise.octaves = 1
	cloud_noise.period = 100.0
	cloud_noise.persistence = 0.3
	
	cloud_2_noise.seed = randi()
	cloud_2_noise.octaves = 1
	cloud_2_noise.period = 120.0
	cloud_2_noise.persistence = 0.3
	
	spawn_nature()

func _process(_delta):
	change_height()

func spawn_nature():
	set_tilemap()
	
	
	#trees
	var tree_x = -tree_range
	while tree_x < tree_range:
		var tree_y = -tree_range
		tree_x += tree_step_size
		while tree_y < tree_range:
			tree_y += tree_step_size
			
			var noise_value = tree_noise.get_noise_2d(tree_x, tree_y)
			if noise_value >= tree_threshhold:
				spawn_tree(tree_x, tree_y)
			
			if noise_value <= dirt_threshhold:
				spawn_dirt_hill(tree_x, tree_y)
			elif noise_value <= partner_threshhold:
				spawn_partner(tree_x, tree_y)
			elif noise_value <= deco_threshhold:
				spawn_deco(tree_x, tree_y)
	
	#clouds
	var cloud_x = -tree_range
	while cloud_x <= tree_range:
		var cloud_y = -tree_range
		cloud_x += cloud_step
		while cloud_y < tree_range:
			cloud_y += cloud_step
			
			var noise_value = cloud_noise.get_noise_2d(cloud_x, cloud_y)
			if noise_value <= cloud_threshhold:
				spawn_cloud(cloud_x, cloud_y, 1)
	
	#clouds 2
	cloud_x = -tree_range
	while cloud_x <= tree_range:
		var cloud_y = -tree_range
		cloud_x += cloud_2_step
		while cloud_y < tree_range:
			cloud_y += cloud_2_step
			
			var noise_value = cloud_noise.get_noise_2d(cloud_x, cloud_y)
			if noise_value <= cloud_threshhold:
				spawn_cloud(cloud_x, cloud_y, 2)

func set_tilemap():
	var numbers = []
	for _x in range(0, 3):
		for y in range(0, 8):
			numbers.append(y)
	
	var pos = 0
	numbers.shuffle()
	
	var tile_x = -tree_range/1000
	while tile_x < tree_range/1000:
		var tile_y = -tree_range/1000
		tile_x += 1
		while tile_y < tree_range/1000:
			tile_y += 1
			tilemap.set_cell(tile_x, tile_y, numbers[pos])
			pos += 1
			if pos >= len(numbers):
				pos = 0
				numbers.shuffle()

func spawn_tree(x, y):
	var tree = load("res://scenes/tree.tscn").instance()
	tree.position = Vector2(x, y)
	var animation = randi() % 3
	match animation:
		0:
			tree.animation = 'oak'
		1:
			tree.animation = 'birch'
		2:
			tree.animation = 'pine'
	
	trees.append(tree)
	spawn_branches(tree, x, y)
	add_child(tree)

func spawn_branches(tree, x, y):
	var branch_x = -branch_range
	while branch_x < branch_range:
		branch_x += branch_step
		var branch_y = -branch_range
		while branch_y < branch_range:
			branch_y += branch_step
			
			var noise_value = branch_noise.get_noise_2d(branch_x + x, branch_y + y)
			
			if noise_value <= branch_threshhold:
				var branch = load("res://scenes/branch.tscn").instance()
				branch.position = Vector2(branch_x + x, branch_y + y)
				branch.rotation_degrees = randi() % 360
				branch.animation = tree.animation
				branches.append(branch)
				add_child(branch)

func spawn_dirt_hill(x, y):
	var dirt_hill = load("res://scenes/dirt_hill.tscn").instance()
	dirt_hill.position = Vector2(x, y)
	dirt_hill.rotation_degrees = randi() % 360
	var animation = randi() % 2
	dirt_hill.animation = str(animation)
	add_child(dirt_hill)
	
	spawn_worms(x, y)

func spawn_worms(x, y):
	var worm_x = -worm_range
	while worm_x < worm_range:
		worm_x += worm_step
		var worm_y = -worm_range
		while worm_y < worm_range:
			worm_y += worm_step
			
			var noise_value = branch_noise.get_noise_2d(worm_x + x, worm_y + y)
			
			if noise_value <= worm_threshhold:
				var worm = load("res://scenes/worm.tscn").instance()
				worm.position = Vector2(worm_x + x, worm_y + y)
				worm.rotation_degrees = randi() % 360
				worms.append(worm)
				add_child(worm)

func spawn_partner(x, y):
	var partner = load("res://scenes/partner.tscn").instance()
	partner.position = Vector2(x, y)
	partner.rotation_degrees = randi() % 360
	partners.append(partner)
	add_child(partner)

func spawn_deco(x, y):
	var deco = load("res://scenes/deco.tscn").instance()
	deco.position = Vector2(x, y)
	deco.rotation_degrees = randi() % 360
	var animation = randi() % 7
	deco.animation = str(animation)
	add_child(deco)

func spawn_cloud(x, y, factor):
	var cloud = load("res://scenes/cloud.tscn").instance()
	cloud.position = Vector2(x, y)
	cloud.rotation_degrees = randi() % 360
	var animation = randi() % 8
	cloud.frame = animation
	cloud.modulate = Color(1, 1, 1, 0)
	
	var transparency = float(50+(randi() % 50))/100
	cloud.transparency = transparency
	
	var scale_multiplier = (float(100+(randi() % 100))/25) * factor
	cloud.scale = Vector2(scale_multiplier, scale_multiplier)
	
	match factor:
		1:
			clouds_1.append(cloud)
		2:
			clouds_2.append(cloud)
	add_child(cloud)

func change_height():
	if player.height != player.new_height:
		player.height = player.new_height
		
		if player.height < player.branches_height:
			var transparency = float(player.height-player.ground_height)/float(player.branches_height-player.ground_height)
			if transparency < 0:
				transparency = 0
			for tree in trees:
				tree.self_modulate = Color(1, 1, 1, 0)
				tree.tree_branches.self_modulate = Color(1, 1, 1, transparency)
				tree.tree_log.visible = true
		
		elif player.height < player.treetop_height:
			var transparency = float(player.height-player.branches_height)/float(player.treetop_height-player.branches_height)
			if transparency < 0:
				transparency = 0
			for tree in trees:
				tree.self_modulate = Color(1, 1, 1, transparency)
				tree.tree_branches.visible = true
				tree.tree_log.visible = false
		elif player.height < player.cloud_height_1:
			for tree in trees:
				tree.self_modulate = Color(1, 1, 1, 1)
				tree.tree_branches.visible = false
		
		elif player.height < player.cloud_height_2:
			var transparency = float(player.height-player.cloud_height_1)/float(player.cloud_height_2-player.cloud_height_1)
			for cloud in clouds_1:
				cloud.modulate = Color(1, 1, 1, cloud.transparency * transparency)
		elif player.height < player.cloud_height_3:
			var transparency = float(player.height-player.cloud_height_2)/float(player.cloud_height_3-player.cloud_height_2)
			
			for cloud in clouds_2:
				cloud.modulate = Color(1, 1, 1, cloud.transparency * transparency)