
extends Area2D


@onready var win_screen = $GUI

# Timer to track the time taken
func _ready():
	win_screen.show()
	win_screen.animation.play("Open")

func _process(delta):
	pass
