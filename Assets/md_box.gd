extends RigidBody2D

var picked: bool = false
var def_throw_speed:Vector2 = Vector2(500,350)
var throw_speed:Vector2 = Vector2(300,150)
var max_throw_speed:Vector2 = Vector2(450,450)
@onready var Player: CharacterBody2D

func _ready():
	Player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D
	if !Player:
		return

func _physics_process(delta):

	
	if Global.player_scale == 1:
		$AnimationPlayer.play("Hifriction_2")
		def_throw_speed = Vector2(100,50)
		throw_speed= Vector2(100,50)
		var max_throw_speed= Vector2(150,100)
	else:
		$AnimationPlayer.play("Lowfriction")
		var def_throw_speed:Vector2 = Vector2(500,350)
		var throw_speed:Vector2 = Vector2(300,150)
		var max_throw_speed:Vector2 = Vector2(450,450)
		
		
		
		
	if picked == true and Player:
		if Global.player_scale == 1:
			self.position = Player.item_pos_small.global_position
			Player.big.hand_anim.play("Lift")
			Player.small.hand_anim.play("Lift")
		else:
			self.position = Player.itempos.global_position
			Player.big.hand_anim.play("Lift")
			Player.small.hand_anim.play("Lift")
		Player.big.max_speed = 4000
		Player.small.max_speed = 3000
		Player.small.jump_force = 500
		Player.big.jump_force = 400
	if Input.is_action_pressed("Throw"):
		picked = false
		$Grab.play()
		Player.can_pick = true  # Allow picking up other objects
		Player.big.hand_anim.play("Drag")
		Player.small.hand_anim.play("Drag")
		reset_value()

func _input(event):
	if Input.is_action_just_pressed("Pick"):
		if picked:
			# Drop the object
			picked = false
			$Grab.play()
			Player.big.hand_anim.play("Drag")
			Player.small.hand_anim.play("Drag")
			reset_value()
			Player.can_pick = true  # Allow picking up other objects
		elif Player.can_pick:
			var bodies = $Area2D.get_overlapping_bodies()
			for body in bodies:
				if body.name == "Bot":
					picked = true
					$Grab.play()
					Player.can_pick = false  # Prevent picking up another object while holding one
func reset_value():
	Player.big.max_speed = 5000
	Player.small.max_speed = 13000
	Player.small.jump_force = 900
	Player.big.jump_force = 500
