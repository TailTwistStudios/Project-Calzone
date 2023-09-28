extends Node3D


func _ready():
	var default_world = preload("res://scenes/default_worlds/default_world.tscn")
	var world_instance = default_world.instantiate()
	add_child(world_instance)
