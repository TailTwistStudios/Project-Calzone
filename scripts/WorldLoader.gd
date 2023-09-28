extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var default_world = preload("res://scenes/default_world.tscn")
	var world_instance = default_world.instantiate()
	add_child(world_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
