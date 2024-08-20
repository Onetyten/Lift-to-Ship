extends CanvasLayer
var Next_level
var Time_taken:float
@export_file("*.tscn") var next_level

@onready var animation =$Control/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$"Control/Sprite2D/VBoxContainer/Time box/time".text = str(Time_taken)+"seconds"


func _on_previous_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	


func _on_next_pressed():
	get_tree().paused = false
	if next_level != null:
		get_tree().change_scene_to_file(next_level)
	else:
		get_tree().change_scene_to_file("res://Levels/Ware1.tscn")
	
