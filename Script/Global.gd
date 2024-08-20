extends Node
var dashing = false
var enter_dashing = false
var dash_meter:int = 100
var player_current_pos = Vector2(-405,-92)
var x_dir := 1
# a scale of 2 represents big while one represents small
var player_scale = 2


func _ready():
	pass
func _process(_delta):
	if dash_meter <0:
		dash_meter= 0
	if dash_meter >100:
		dash_meter= 100
func _input(event):
	if Input.is_action_just_pressed('ui_cancel'):
		get_tree().reload_current_scene()
