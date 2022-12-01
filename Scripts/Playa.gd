extends KinematicBody

export var speed = 10
export var accel = 10
export var sprint_speed = 18
export var gravity = 50
export var jump = 15
export var sensitivity = 0.2
export var max_angle = 90
export var min_angle = -80

onready var head = $Head
onready var object_look = $Head/ObjectLook
onready var object_name = $Head/UI/object_name

onready var screen_texture = $Head/UI/Wrist/ScreenTexture
onready var wrist = $Head/UI/Wrist

var jumping = false
var look_rot = Vector3.ZERO
var move_dir = Vector3.ZERO
var velocity = Vector3.ZERO
var current_speed = speed

func _ready():
	self.translation = $RayCast.get_collision_point() + Vector3(0,20,0)
	$RayCast.enabled = false
	Global.player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	#set rotation
	if object_look.is_colliding():
		object_name.text = str(object_look.get_collider().name)
	else:
		object_name.text = "NULL"
	head.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y
	if not is_on_floor():
		velocity.y -= gravity * delta
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump
	if Input.is_action_just_pressed("flashlight"):
		if $Head/Flashlight.visible == false:
			$Head/Flashlight.visible = true
		else:
			$Head/Flashlight.visible = false
	if Input.is_action_just_pressed("map"):
		if $Head/UI/Wrist/Screens/Map.visible == false:
			enable_screen($Head/UI/Wrist/Screens/Map,Color("962d2d"))
		else:
			disable_screen($Head/UI/Wrist/Screens/Map)
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
		$animationplaya.play("breath")
	else:
		$animationplaya.play("walk")
	if Input.is_action_pressed("sprint"):
		current_speed = sprint_speed
		print("HOLDING SHIFT")
	else:
		current_speed = speed
	if Input.is_action_pressed("move_left"):
		$Head.rotation.z = lerp($Head.rotation.z,deg2rad(6),0.1)
	elif Input.is_action_pressed("move_right"):
		$Head.rotation.z = lerp($Head.rotation.z,deg2rad(-6),0.1)
	else:
		$Head.rotation.z = lerp($Head.rotation.z,deg2rad(0),0.2)
	velocity.x = lerp(velocity.x, move_dir.x * current_speed, accel * delta)
	velocity.z = lerp(velocity.z, move_dir.z * current_speed, accel * delta)
	velocity = move_and_slide(velocity, Vector3.UP,true)
	#var snap_vector = Vector3.DOWN if not jumping else Vector3.ZERO
	#velocity = move_and_slide_with_snap(velocity,snap_vector,Vector3.UP)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		look_rot.y -= (event.relative.x * sensitivity)
		look_rot.x -= (event.relative.y * sensitivity)
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)

func enable_screen(node_path,color):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	wrist.rect_scale = Vector2(1,0)
	node_path.visible = true
	wrist.visible = true
	screen_texture.modulate = Color.black
	node_path.modulate = Color.black
	tween.parallel().tween_property(wrist,"rect_scale",Vector2(1,1),0.2)
	tween.parallel().tween_property(node_path,"modulate",Color(1,1,1,1),0.2)
	tween.tween_property(screen_texture,"modulate",color,0.2)

func disable_screen(node_path):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(wrist,"rect_scale",Vector2(1,0),0.2)
	tween.parallel().tween_property(screen_texture,"modulate",Color.black,0.2)
	tween.tween_property(node_path,"modulate",Color.black,0.2)
	yield(tween,"finished")
	node_path.visible = false
	wrist.visible = false

func die():
	var tween = create_tween()
	tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	tween.tween_property($Head/WaterDeath,"rect_size",Vector2(256,224),1)
	tween.tween_interval(0.5)
	yield(tween,"finished")
	get_tree().reload_current_scene()
	get_tree().paused = false

func slow_death():
	get_tree().paused = true
	var tween = create_tween()
	tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	tween.tween_property($Head/SlowDeath,"modulate",Color(1,1,1,1),3)
	yield(tween,"finished")
	get_tree().reload_current_scene()
	get_tree().paused = false
