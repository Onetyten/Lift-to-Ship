class_name Player
extends CharacterBody2D
@export var big:NodeState
@export var small:NodeState
@onready var itempos:Marker2D
@onready var dragPos:Marker2D
var can_pick:bool = true
var push_force:int = 80
var direction = 1
var reset_position: Vector2
@export var item_pos_big:Marker2D
@export var item_pos_small:Marker2D
@export var dragPos_big:Marker2D
@export var dragPos_small:Marker2D
@export var finite_state_machine:FiniteStateMachine



func _physics_process(delta):
	if Global.player_scale == 1:
		itempos = item_pos_small
		dragPos = dragPos_big
	else:
		itempos = item_pos_big
		dragPos = dragPos_small
	move_and_slide()
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		if col.get_collider() is RigidBody2D:
			col.get_collider().apply_central_impulse(-col.get_normal()*push_force)


#func _on_col_cancel_body_entered(body):
	#if Global.player_scale == 2:
		#collision_mask = 1
#
#
#func _on_col_cancel_body_exited(body):
	#if Global.player_scale == 2:
		#collision_mask = 2

func on_enter():
	reset_position = position


func die():
		get_tree().reload_current_scene()
#

#
#func _on_col_cancel_small_body_entered(body):
	#if Global.player_scale == 1:
		#collision_mask = 1
#
#
#func _on_col_cancel_small_body_exited(body):
	#if Global.player_scale == 1:
		#collision_mask = 2
