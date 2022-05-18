extends KinematicBody2D

onready var parent = get_parent()
onready var animation = $animation
onready var shadow = $shadow
onready var arrow = $arrow
onready var level

var dir = Vector2(0, 0)
var old_dir = Vector2(0, 0)
var hori_speed = 400

var height = 1000
var new_height = height
var height_change = -1
var gravity = .22
var max_fall_speed = -8
var verti_speed = 7 #odl was 4

var swing_cooldown = 30
var swing_cooltimer = 0

var cloud_height_3 = 3000
var cloud_height_2 = 2000
var cloud_height_1 = 1150
var treetop_height = 750
var branches_height = 500
var ground_height = 300

var collectables = []

var grounded = false

var shadow_offset = Vector2(-10, 10)

func ready():
	level = parent.level

func _process(_delta):
	inputs()
	
	horizontal_movement()
	vertical_movement()
	
	adjusting_shadow()
	
	if parent.phase > 0:
		var angel = (position - level.nest.position).normalized()
		arrow.rotation = angel.angle() - PI/2
		arrow.position = angel * -100

func set_animation(ani):
	animation.animation = ani
	animation.frame = 0

func inputs():
	dir = Vector2(0, 0)
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	
	if !(!(Input.is_action_pressed("ui_left")) 
	and !(Input.is_action_pressed("ui_right")) 
	and !(Input.is_action_pressed("ui_up")) 
	and !(Input.is_action_pressed("ui_down"))):
		old_dir = dir
	
	#if Input.is_action_pressed("fly_up"):
	#	new_height += verti_speed
	#if Input.is_action_pressed("fly_down"):
	#	new_height -= verti_speed
	if swing_cooltimer <= 0:
		if Input.is_action_pressed("ui_accept"):
			height_change = verti_speed
			set_animation('flapping')
			swing_cooltimer = swing_cooldown
	else:
		swing_cooltimer -= 1
	
	#if height <= treetop_height:
	#	if Input.is_action_just_pressed("ui_accept"):
	#		var collected = collectables.pop_front()
	#		if collected != null:
	#			collected.queue_free()
	pass

func horizontal_movement():
	dir = dir.normalized()
	move_and_slide(dir * hori_speed  * height/100.0)
	animation.rotation = old_dir.angle() + PI/2

func vertical_movement():
	new_height += height_change
	
	if new_height < ground_height:
		new_height = ground_height
		
		if grounded == false:
			set_animation('landing')
			grounded = true
		
	elif grounded == true:
		grounded = false
	
	height_change -= gravity
	if height_change < max_fall_speed:
		height_change = max_fall_speed
	
	scale = Vector2(1, 1) * height/100.0

func adjusting_shadow():
	var absolute_height = (height-ground_height)/4
	shadow.position = Vector2(-absolute_height, absolute_height) + shadow_offset
	var transparency = 1-(float(height)/float(cloud_height_1))
	shadow.modulate = Color(0, 0, 0, transparency)
	shadow.rotation = animation.rotation
	shadow.frame = animation.frame
	shadow.animation = animation.animation

func _on_collect_area_area_entered(area):
	match parent.phase:
		0:
			if area in level.partners and grounded:
				area.queue_free()
				parent.partner_count += 1
				if parent.partner_count >= parent.partner_max:
					for partner in level.partners:
						partner.queue_free()
					parent.next_phase()
		1, 2, 3:
			if area in level.branches and grounded:
				if parent.branch_count < parent.branch_max:
					area.queue_free()
					parent.branch_count += 1
					set_animation('collecting')
			if area == level.nest:
				if parent.branch_count >= parent.branch_max:
					parent.branch_count = 0
					parent.next_phase()
		4, 5, 6:
			if area in level.worms and grounded:
				area.queue_free()
				parent.worm_count += 1
				set_animation('collecting')
			if area == level.nest:
				if parent.worm_count >= parent.worm_max:
					parent.worm_count = 0
					parent.next_phase()

func _on_animation_animation_finished():
	if grounded:
		set_animation('walking')
	else:
		set_animation('gliding')
