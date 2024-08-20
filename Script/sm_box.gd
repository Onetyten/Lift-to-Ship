extends RigidBody2D

var picked: bool = false
var def_throw_speed:Vector2 = Vector2(500,-350)
var throw_speed:Vector2 = Vector2(500,-350)
var max_throw_speed:Vector2 = Vector2(1000,-750)
@onready var Player: CharacterBody2D

func _ready():
	Player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D
	if !Player:
		return

func _physics_process(delta):
	
	if picked == true and Player:
		self.position = Player.itempos.global_position
		Player.big.hand_anim.play("Lift")
		Player.small.hand_anim.play("Lift")


	if Input.is_action_pressed("Throw"):
		# Drop the object
		picked = false
		Player.can_pick = true  # Allow picking up other objects
		Player.big.hand_anim.play("Drag")
		Player.small.hand_anim.play("Drag")
		$Grab.play()


func _input(event):
	if Input.is_action_just_pressed("Pick"):
		if picked:
			# Drop the object
			picked = false
			Player.can_pick = true  # Allow picking up other objects
			Player.big.hand_anim.play("Drag")
			Player.small.hand_anim.play("Drag")
			$Grab.play()
		elif Player.can_pick:
			var bodies = $Area2D.get_overlapping_bodies()
			for body in bodies:
				if body.name == "Bot":
					picked = true
					Player.can_pick = false 
					$Grab.play()
			 # Prevent picking up another object while holding one
