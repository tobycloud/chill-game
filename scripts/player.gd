extends CharacterBody3D
class_name Player

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
var was_emit_die = false
var lerp_spd = 10.0

var direction = Vector3.ZERO

@export var walking_speed = 3
@export var running_speed = 5

@export_category("Nodes")
@export_node_path("Node3D") var node_path

@onready var model = get_node(node_path) as Node3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target_rotation = Vector2()
var rotation_speed = 0.1
var z_rotation_decay = 0.02
var z_rotation_speed = 0.05
var z_rotation_deceleration = 0.04
var z_rotation_acceleration = 0
var max_z_rotation_speed = 0.5
var current_z_rotation_speed = 0.0
var locked = false

var prev_target_rotation = Vector2()

func _ready():
	if animation_player.current_animation != "idle":
		animation_player.play("idle")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	model.visible = false

func _input(event):
	if Input.is_action_just_pressed("switch_cam"):
		if third.current:
			first.current = true
			third.current = false
		else:
			first.current = false
			third.current = true
			visuals.show()
	if event is InputEventMouseMotion:
		if !is_locked_cam:
			rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
			visuals.rotate_y(deg_to_rad(event.relative.x * sens_horizontal))
		
			camera_mount.rotate_x(deg_to_rad(-event.relative.y*sens_vertical))
			camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-89), deg_to_rad(89))
			# if first.current:
			#	camera_mount.rotation.x = clamp(camera_mount.rotation.x, -1, 1)
		else:
			rotate_y(deg_to_rad(0))
			rotation.z = 0.0


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
		if running:
			velocity.y += 2 # extra velocity if running

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(
		direction, 
		(transform.basis*Vector3(input_dir.x, 0.01, input_dir.y)).normalized(),
		delta*lerp_spd+sin(deg_to_rad(delta/2))
	)
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
signal PlayerDie
func _process(delta):
	apply_smooth_rotation(delta)
	z_shaking(delta)
	if(global_position[1] <=-100) && !was_emit_die:
		PlayerDie.emit()
		was_emit_die = true

func on_Esc(cam):
	if !is_locked:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	is_locked = !is_locked
	if cam:
		is_locked_cam = !is_locked_cam

func reset():
	was_emit_die = false
	self.position = Vector3(0,0,0)

func z_shaking(delta):
	rotation_speed = clamp(rotation.z, 0.01, 0.05)
	if is_locked_cam == true:
		rotation.z = lerp_angle(rotation.z, 0.0, rotation_speed * delta)
		rotation.z = clamp(rotation.z, deg_to_rad(-2), deg_to_rad(2))
		current_z_rotation_speed = 0.0
	else:
		if target_rotation != prev_target_rotation:
			current_z_rotation_speed = 0.0
			rotation.z = 0.0
		current_z_rotation_speed += (transform.basis*Vector3(direction.x, 0.01, direction.y)).x * z_rotation_speed
		# if direction.x == 0.0:
		#	current_z_rotation_speed = lerp(current_z_rotation_speed, 0.01, z_rotation_decay)
		
		if (abs(rotation.z) > deg_to_rad(5)) or (abs(rotation.z) < deg_to_rad(-5)):
			current_z_rotation_speed -= sign(rotation.z) * z_rotation_deceleration * delta
		current_z_rotation_speed = clamp(current_z_rotation_speed, -max_z_rotation_speed, max_z_rotation_speed)
		
		rotation.z += current_z_rotation_speed * delta
		rotation.z = fmod(rotation.z, (2 * PI))
		rotation.z = clamp(rotation.z, deg_to_rad(-5), delta*lerp_spd*deg_to_rad(5))
	prev_target_rotation = target_rotation
func apply_smooth_rotation(delta):
	if is_locked_cam:
		rotation.y = 0.0
	else:
		rotation.y = lerp_angle(rotation.y, target_rotation.y, rotation_speed * delta)
	
func lerp_angle(a, b, t):
	var result = a + (b - a) * t
	if abs(b - a) > PI:
		result += PI * 2 if (b < a) else -PI * 2
	return result
