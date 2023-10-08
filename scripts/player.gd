extends CharacterBody3D

@onready var third = $camera_mount/third
@onready var first = $camera_mount/first
@onready var camera_mount = $camera_mount
@onready var animation_player = $visuals/mixamo_base/AnimationPlayer
@onready var visuals = $visuals


@export var sens_horizontal = 0.5
@export var sens_vertical = 0.5


var SPEED = 3
const JUMP_VELOCITY = 5
var running = false
var is_locked = false
var is_locked_cam = false

@export var walking_speed = 3
@export var running_speed = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	if animation_player.current_animation != "idle":
		animation_player.play("idle")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if Input.is_action_just_pressed("switch_cam"):
		if third.current:
			first.current = true
			third.current = false
		else:
			first.current = false
			third.current = true
	if event is InputEventMouseMotion:
		if !is_locked_cam:
			rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
			visuals.rotate_y(deg_to_rad(event.relative.x * sens_horizontal))
			camera_mount.rotate_x(deg_to_rad(-event.relative.y*sens_vertical))


func _physics_process(delta):
	if Input.is_action_pressed("run"):
		SPEED = running_speed
		running = true
	else:
		SPEED = walking_speed
		running = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if !is_locked:
			if running:
				if animation_player.current_animation != "running":
					animation_player.play("running")
			else:
				if animation_player.current_animation != "walking":
					animation_player.play("walking");
			visuals.look_at(position + direction)
		else:
			if animation_player.current_animation != "idle":
					animation_player.play("idle")

		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if animation_player.current_animation != "idle":
			animation_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if !is_locked:
		move_and_slide()

func on_Esc(cam):
	if !is_locked:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	is_locked = !is_locked
	if cam:
		is_locked_cam = !is_locked_cam
