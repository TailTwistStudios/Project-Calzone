extends CharacterBody3D

class_name PlayerBody

signal PlayerLeave

@export var speed = 5.0
@export var jump_velocity = 4.5
@onready var nameLabel : Label3D = $NameLabel
var username : String


func _ready():
	nameLabel.text = str(get_multiplayer_authority())

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _on_player_leave(id : int):
	if id == get_multiplayer_authority():
		queue_free()
