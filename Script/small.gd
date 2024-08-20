extends NodeState
@export var character :CharacterBody2D
@export var finite_state_machine:FiniteStateMachine
@export var dash_timer:Timer
@export var sprite_animation:AnimationPlayer
@export var state_animation:AnimationPlayer
@export var direction_player:AnimationPlayer
@export var big_state:NodeState
var face_direction := 1
@export var max_speed: float = 560
@export var acceleration: float = 2880
@export var turning_acceleration : float = 9600
@export var deceleration: float = 3200
@export var gravity_acceleration : float = 3840
@export var gravity_max : float = 1020
@export var jump_force : float = 1400
@export var jump_cut : float = 0.25
@export var jump_gravity_max : float = 500
@export var jump_hang_treshold : float = 2.0
@export var jump_hang_gravity_mult : float = 0.1
@export var jump_coyote : float = 0.08
@export var jump_buffer : float = 0.1
@export var dash_particles:GPUParticles2D
@export var particle_anim:AnimationPlayer
@export var hand_anim:AnimationPlayer
var dashing:bool  = false
@export var explosion:GPUParticles2D
@export var explosion_sfx:AudioStreamPlayer2D
@export var jump_sfx:AudioStreamPlayer2D
@export var dash_sfx:AudioStreamPlayer2D
@export var walk_sfx:AudioStreamPlayer2D

var jump_coyote_timer : float = 0
var jump_buffer_timer : float = 0
var is_jumping := false
var is_grounded
var landing:bool
var animation: String
var new_animation = &"Idle"
var falling = true
var dashspeed =4000
var can_dash = true
var dash_direction =Vector2(1,0)
@onready var timer =$Timer




func _ready():
	hand_anim.play("Drag")
	character.position = Global.player_current_pos
	

func on_process(_delta):
	update_animation_paremeters()
	switch_up()
	
func get_input() -> Dictionary:
	return {
		"x": int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left")),
		"just_jump": Input.is_action_just_pressed("Jump") == true,
		"jump": Input.is_action_pressed("Jump") == true,
		"released_jump": Input.is_action_just_released("Jump") == true
	}


func on_physics_process(delta:float):
	x_movement(delta)
	jump_logic(delta)
	apply_gravity(delta)
	timers(delta)
	character.move_and_slide()
	set_direction(character.direction)


func x_movement(delta:float) -> void:
	dash()
	character.direction = get_input()["x"]
	if character.direction:
		walk_sfx.play()
		
	var direction = Input.get_axis("Left", "Right")
	
	if direction:
		if dashing == false:
			character.velocity.x = direction * max_speed*delta
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, max_speed)
	character.move_and_slide()

func set_direction(hor_direction) -> void:
	if character.direction == 0:
		return
	if character.direction >0:
		direction_player.play("Right")
	else:
		direction_player.play("Left")
	
	face_direction = hor_direction # remember direction
	
func jump_logic(_delta: float) -> void:
	# Reset our jump requirements
	if character.is_on_floor():
		jump_coyote_timer = jump_coyote
		is_jumping = false
	if get_input()["just_jump"]:
		
		jump_buffer_timer = jump_buffer
		
	
	# Jump if grounded, there is jump input, and we aren't jumping already
	if jump_coyote_timer > 0 and jump_buffer_timer > 0 and not is_jumping:
		jump_sfx.play()
		is_jumping = true
		jump_coyote_timer = 0
		jump_buffer_timer = 0
		# If falling, account for that lost speed
		if character.velocity.y > 0:
			character.velocity.y -= character.velocity.y
		character.velocity.y = -jump_force

	if get_input()["released_jump"] and character.velocity.y < 0:
		character.velocity.y = 0 
		jump_sfx.play()
	if character.is_on_ceiling(): character.velocity.y = jump_hang_treshold + 100.0


func apply_gravity(delta: float) -> void:

	var applied_gravity : float = 0
	
	# No gravity if we are grounded
	if jump_coyote_timer > 0:
		return
	
	# Normal gravity limit
	if character.velocity.y <= gravity_max:
		applied_gravity = gravity_acceleration * delta
	
	# If moving upwards while jumping, the limit is jump_gravity_max to achieve lower gravity
	if (is_jumping and character.velocity.y < 0) and character.velocity.y > jump_gravity_max:
		applied_gravity = 0
	
	# Lower the gravity at the peak of our jump (where velocity is the smallest)
	if is_jumping and abs(character.velocity.y) < jump_hang_treshold:
		applied_gravity *= jump_hang_gravity_mult
	
	character.velocity.y += applied_gravity


func timers(delta: float) -> void:
	jump_coyote_timer -= delta
	jump_buffer_timer -= delta

func dash():
	character.direction= get_input()["x"]
	if character.direction ==1:
		dash_direction=Vector2(1,0)
		#Global.start_tonified = false
	elif  character.direction ==-1:
		dash_direction =Vector2(-1,0)
		#Global.start_tonified = false
	if dashing:
		character.velocity = dash_direction.normalized()*500
	if Input.is_action_just_pressed("Dash") and can_dash and Global.dash_meter>0:
		dash_sfx.play()
		dashing=true
		dash_timer.start()
		await get_tree().create_timer(.5).timeout
		dashing =false
		can_dash =false

func update_animation_paremeters():
	
	var new_animation = &"Idle"
	if character.velocity.y < 0:
			new_animation = &"Jump"
	elif character.velocity.y >= 0 and not character.is_on_floor():
		new_animation = &"Fall"
	elif absf(character.velocity.x) > 1:
		new_animation = &"Run"
	if new_animation != animation:
		animation = new_animation


func switch_up():
	if Input.is_action_just_pressed("Switch"):
		finite_state_machine.transition_to("Big")

func enter():
	Global.player_scale = 1
	state_animation.play("small")

	
func exit():
	Global.player_scale = 2
	explosion.restart()
	explosion_sfx.play()
	


func _on_dash_timer_timeout():
	can_dash = true
