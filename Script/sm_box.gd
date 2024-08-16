extends RigidBody2D
var picked:bool = false
var weight = 1
@onready var Player:CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _physics_process(delta):
	if picked == true:
		self.position = get_node(Player.headpos).global_position
