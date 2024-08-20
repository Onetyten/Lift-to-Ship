extends RigidBody2D

var picked: bool = false
@onready var Player: CharacterBody2D

func _ready():
	Player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D
	if !Player:
		return

func _physics_process(delta):
	if picked == true and Player:
		if Global.player_scale == 1:
			self.position = Player.item_pos_small.global_position
		else:
			self.position = Player.item_pos_big.global_position
		Player.big.hand_anim.play("Lift")
		Player.small.hand_anim.play("Lift")
		Player.big.max_speed = 2000
		Player.big.jump_force = 0
		Player.small.max_speed = 0
		Player.small.jump_force = 0

func _input(event):
	if Input.is_action_just_pressed("Pick"):
		if picked:
			# Drop the object
			picked = false
			Player.can_pick = true
			Player.big.hand_anim.play("Drag")
			Player.small.hand_anim.play("Drag")
			$Grab.play()
			reset_value()

		elif Player.can_pick:
			var bodies = $Area2D.get_overlapping_bodies()
			for body in bodies:
				if body.name == "Bot":
					picked = true
					$Grab.play()
					Player.can_pick = false  # Prevent picking up another object while holding one
	if Input.is_action_just_pressed("Throw"):
		if picked:
			# Drop the object
			picked = false
			Player.can_pick = true
			Player.big.hand_anim.play("Drag")
			Player.small.hand_anim.play("Drag")
			$Grab.play()
			reset_value()


func reset_value():
	Player.big.max_speed = 5000
	Player.small.max_speed = 13000
	Player.small.jump_force = 900
	Player.big.jump_force = 500
