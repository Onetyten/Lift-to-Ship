extends Node2D
@export var big_cam:PhantomCamera2D
@export var small_cam:PhantomCamera2D
@export var camera:Camera2D



# Called when the node enters the scene tree for the first time.
func _ready():
	big_cam.set_priority(0)
	small_cam.set_priority(100)
	#camera.drag_horizontal_enabled = false
	#camera.drag_vertical_enabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Switch_cam"):
		if big_cam.priority == 100:
			big_cam.set_priority(0)
			small_cam.set_priority(100)
			#camera.drag_horizontal_enabled = true
			#camera.drag_vertical_enabled = true
		elif small_cam.priority == 100:
			small_cam.set_priority(0)
			big_cam.set_priority(100)
			#camera.drag_horizontal_enabled = false
			#camera.drag_vertical_enabled = false
			
