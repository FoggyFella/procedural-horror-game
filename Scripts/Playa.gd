extends KinematicBody

export var speed = 10
export var accel = 10
export var gravity = 50
export var jump = 15
export var sensitivity = 0.2
export var max_angle = 90
export var min_angle = -80

onready var head = $Head

var jumping = false
var look_rot = Vector3.ZERO
var move_dir = Vector3.ZERO
var velocity = Vector3.ZERO

func _ready():
	self.translation = $RayCast.get_collision_point() + Vector3(0,2,0)
	$RayCast.enabled = false
	Global.player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	#set rotation
	head.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y
	if not is_on_floor():
		velocity.y -= gravity * delta
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump
	if Input.is_action_just_pressed("flashlight"):
		if $Head/SpotLight.visible == false:
			$Head/SpotLight.visible = true
		else:
			$Head/SpotLight.visible = false
	if Input.is_action_just_pressed("map"):
		if $Head/Camera/UI/Map.visible == false:
			$Head/Camera/UI/Map.visible = true
		else:
			$Head/Camera/UI/Map.visible = false
	if Input.is_action_just_pressed("show_mouse"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	move_dir = Vector3(
		Input.get_axis("move_left", "move_right"),
		0,
		Input.get_axis("move_forward", "move_backwards")
	).normalized().rotated(Vector3.UP, rotation.y)
	
	if move_dir == Vector3.ZERO:
		$Head/Camera/animationplaya.play("breath")
	else:
		$Head/Camera/animationplaya.play("walk")
	if Input.is_action_pressed("move_left"):
		$Head.rotation.z = lerp($Head.rotation.z,deg2rad(6),0.1)
	elif Input.is_action_pressed("move_right"):
		$Head.rotation.z = lerp($Head.rotation.z,deg2rad(-6),0.1)
	else:
		$Head.rotation.z = lerp($Head.rotation.z,deg2rad(0),0.2)
	velocity.x = lerp(velocity.x, move_dir.x * speed, accel * delta)
	velocity.z = lerp(velocity.z, move_dir.z * speed, accel * delta)
	velocity = move_and_slide(velocity, Vector3.UP,true)
	#var snap_vector = Vector3.DOWN if not jumping else Vector3.ZERO
	#velocity = move_and_slide_with_snap(velocity,snap_vector,Vector3.UP)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		look_rot.y -= (event.relative.x * sensitivity)
		look_rot.x -= (event.relative.y * sensitivity)
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)

func move_camera():
	$Head/Camera/UI/Panel/ViewportContainer/Viewport/Camera.global_translation.x = self.global_translation.x
	$Head/Camera/UI/Panel/ViewportContainer/Viewport/Camera.global_translation.z = self.global_translation.z
