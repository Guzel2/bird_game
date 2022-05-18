extends Camera2D

onready var parent = get_parent()
onready var weather = $weather
var player

func ready():
	player = parent.player
	weather.visible = false

func _process(_delta):
	position = player.position
	zoom = player.scale
	weather.scale = zoom * Vector2(.65, .65)

func set_weather(animation):
	weather.animation = animation
	weather.frame = randi() % 6
	weather.playing = true
	weather.visible = true
	weather.rotation_degrees = 45
