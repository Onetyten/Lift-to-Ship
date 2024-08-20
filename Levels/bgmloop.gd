extends AudioStreamPlayer



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _ready():
	volume_db = -14.0


func _on_finished():
	play()
