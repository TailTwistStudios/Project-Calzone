extends Node3D

class_name DesktopPilot

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera : Camera3D = $Camera3D
@onready var menu : CanvasLayer = $"../MenuCanvas"
@onready var playerBody : PlayerBody = $".."
@onready var pickupRaycast : RayCast3D = $Camera3D/InteractRay


func _ready():
	if is_multiplayer_authority():
		camera.current = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		menu.visible = false


func _input(event):
	if not is_multiplayer_authority() or menu.visible: return
	if event is InputEventMouseMotion:
		playerBody.rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)


func _unhandled_input(_event):
	if not is_multiplayer_authority(): return
	if menu.visible: return


func _physics_process(delta):
	if not is_multiplayer_authority(): return
	# Add the gravity.
	if not playerBody.is_on_floor():
		playerBody.velocity.y -= gravity * delta

	#MenuToggle
	if Input.is_action_just_pressed("menu"):
		if menu.visible:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		menu.visible = not menu.visible
	if menu.visible: return

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and playerBody.is_on_floor():
		playerBody.velocity.y = playerBody.jump_velocity

	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (playerBody.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		playerBody.velocity.x = direction.x * playerBody.speed
		playerBody.velocity.z = direction.z * playerBody.speed
	else:
		playerBody.velocity.x = move_toward(playerBody.velocity.x, 0, playerBody.speed)
		playerBody.velocity.z = move_toward(playerBody.velocity.z, 0, playerBody.speed)

	playerBody.move_and_slide()
	
	
	# Interaction
	if (pickupRaycast.is_colliding()):
		var colliding_node : Node = pickupRaycast.get_collider()
		var interactible = colliding_node.find_child("Interactible")
		if (interactible is Interactible):
			#print(interactible.interact_prompt);
			pass
		
