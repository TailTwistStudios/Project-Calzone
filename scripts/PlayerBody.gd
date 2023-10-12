extends CharacterBody3D

class_name PlayerBody

signal PlayerLeave

@export var speed = 5.0
@export var jump_velocity = 4.5
@onready var nameLabel : Label3D = $NameLabel
var username : String

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	nameLabel.text = str(get_multiplayer_authority())
	
	if not is_multiplayer_authority(): return
	print(XRServer.get_interfaces())
	
	if XRServer.find_interface("SteamVR"):
		print("We have an XR interface!")
	else:
		print("Failed to initialize VR");

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _physics_process(_delta):
	if not is_multiplayer_authority(): return
	if not is_on_floor():
		velocity.y -= gravity * _delta
	move_and_slide()


func _on_player_leave(id : int):
	if id == get_multiplayer_authority():
		queue_free()
