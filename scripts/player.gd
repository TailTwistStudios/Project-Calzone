extends CharacterBody3D


signal PlayerLeave

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
#var playerName : String = "": set = setPlayerName
@onready var camera : Camera3D = $Camera3D
@onready var menu : CanvasLayer = $MenuCanvas
@onready var nameLabel : Label3D = $NameLabel
var username : String


func _ready():
	nameLabel.text = str(get_multiplayer_authority())
	
	if is_multiplayer_authority():
		camera.current = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		menu.visible = false
	

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _input(event):
	if not is_multiplayer_authority() or menu.visible: return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	if menu.visible: return
	


func _physics_process(delta):
	if not is_multiplayer_authority(): return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	#MenuToggle
	if Input.is_action_just_pressed("menu"):
		if menu.visible:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		menu.visible = not menu.visible
		
	if menu.visible: return

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_player_leave(id : int):
	if id == get_multiplayer_authority():
		queue_free()
