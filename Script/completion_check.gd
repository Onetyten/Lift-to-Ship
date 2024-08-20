extends Area2D

# Group name for targets
const TARGET_GROUP = "box"

var time_start = 0
var time_now  = 0
@export var bgm:AudioStreamPlayer
@export var bgmloop:AudioStreamPlayer
@onready var win_screen = $GUI

# Timer to track the time taken
var start_time: float

func _ready():
	start_time = Time.get_ticks_msec()/1000.0
	win_screen.hide()
	var target_nodes = get_tree().get_nodes_in_group(TARGET_GROUP)
	print(target_nodes.size())

func _process(delta):
	
	if is_level_completed():
		show_completion_screen()
		win_screen.show()
		win_screen.animation.play("Open")
		if bgm:
			bgm.stream_paused
		if bgmloop:
			bgm.stream_paused
		get_tree().paused = true
		
		
		
		

func is_level_completed() -> bool:
	# Get all nodes in the TARGET_GROUP
	var target_nodes = get_tree().get_nodes_in_group(TARGET_GROUP)
	
	# Get all overlapping bodies
	var overlapping_bodies = get_overlapping_bodies()
	
	# Check if all target nodes are overlapping
	for target in target_nodes:
		if target not in overlapping_bodies:
			return false
	return true

func show_completion_screen():
	var time_taken = Time.get_ticks_msec() / 1000.0 - start_time
	win_screen.Time_taken = time_taken
	
	# Display the time-taken screen (replace with your UI code)
	print("Level completed! Time taken: %s seconds" % time_taken)
	
	# Stop further processing
	set_process(false)


func _on_body_entered(body):
	get_size()


func _on_body_exited(body):
	get_size()
	
	
func get_size():
		# Collect all nodes in the TARGET_GROUP
	var target_nodes = get_tree().get_nodes_in_group(TARGET_GROUP)
	
	# Collect all bodies currently overlapping with the Area2D
	var overlapping_bodies = get_overlapping_bodies()
	
	# List to hold overlapping targets
	var overlapping_targets = []
	
	# Check which target nodes are overlapping
	for target in target_nodes:
		if target in overlapping_bodies:
			overlapping_targets.append(target)
	
	print("Number of target nodes overlapping with Area2D: %d" % overlapping_targets.size())
