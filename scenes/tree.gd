extends AnimatedSprite

onready var parent = get_parent()
onready var tree_log = $log
onready var tree_branches = $branch

func _ready():
	randomize()
	rotation_degrees = randi() % 360
	for child in get_children():
		child.animation = animation
	#	child.rotation_degrees = randi() % 360
	

