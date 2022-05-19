extends Camera2D

onready var parent = get_parent()
onready var weather = $weather
onready var cutscene = $cutscenes
var player

func ready():
	player = parent.player
	weather.visible = false

func _process(_delta):
	position = player.position
	zoom = player.scale
	weather.scale = zoom * Vector2(.65, .65)
	cutscene.scale = zoom

func set_weather(animation):
	weather.animation = animation
	weather.playing = true
	weather.visible = true
	weather.rotation_degrees = 45

func play_cutscene(animation):
	cutscene.animation = animation
	cutscene.playing = true
	cutscene.visible = true


func _on_cutscenes_animation_finished():
	cutscene.playing = false
	cutscene.visible = false
