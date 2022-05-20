extends Camera2D

onready var parent = get_parent()
onready var weather = $weather
onready var cutscene = $cutscenes
onready var credits = $credits
var player

var credit_timer = 0

func ready():
	player = parent.player
	weather.visible = false

func _process(_delta):
	position = player.position
	zoom = player.scale
	weather.scale = zoom * Vector2(.65, .65)
	cutscene.scale = zoom
	
	if player.game_finished:
		credits.scale = zoom
		if credits.visible == false:
			credits.visible = true
			credits.animation = 'credits'
		credit_timer += 1
		if credit_timer < 120:
			var transparency = 1-float(credit_timer)/120
			credits.modulate = Color(1, 1, 1, transparency)
		elif credit_timer == 420:
			#credits.animation = 'thank_you'
			pass
		elif credit_timer >= 660:
			credits.animation = 'black_screen'
			var transparency = float(credit_timer-660)/120
			credits.modulate = Color(1, 1, 1, transparency)
		elif credit_timer == 781:
			player.game_finished = false
			player.position = Vector2(0, 0)
			credits.visible = false
			parent.exit()

func set_weather(animation, degree):
	if animation == 'clear':
		weather.playing = false
		weather.visible = false
	else:
		weather.animation = animation
		weather.playing = true
		weather.visible = true
		weather.rotation_degrees = degree

func play_cutscene(animation):
	cutscene.animation = animation
	cutscene.playing = true
	cutscene.visible = true

func _on_cutscenes_animation_finished():
	cutscene.playing = false
	cutscene.visible = false
