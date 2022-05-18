extends Camera2D

onready var parent = get_parent()
var player

func ready():
	player = parent.player

func _process(_delta):
	position = player.position
	zoom = player.scale
