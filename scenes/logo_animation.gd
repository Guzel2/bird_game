extends AnimatedSprite

onready var parent = get_parent()

func ready():
	animation = 'animation'
	playing = true

func _on_logo_animation_animation_finished():
	animation = 'static_image'
	playing = false
	queue_free()
	parent.ready()
