extends Node
class_name RandomlyPlacedObject

export (PackedScene) var object
export (int) var amount_of_object
var amount = 0
onready var raycast = get_node("RayCast")
var collide_point = null
var normal = null

func _ready():
	setup_raycast()
	randomly_place_ray()
	collide_point = raycast.get_collision_point()
	normal = raycast.get_collision_normal()

func _process(delta):
	if amount < amount_of_object and raycast.is_colliding():
		collide_point = raycast.get_collision_point()
		normal = raycast.get_collision_normal()
		amount += 1
		var object_instance = object.instance()
		object_instance.translation = collide_point
		add_child(object_instance,true)
		object_instance.global_transform = align_with_y(object_instance.global_transform, normal)
		randomly_place_ray()
		raycast.force_raycast_update()
	elif !raycast.is_colliding():
		randomly_place_ray()

func setup_raycast():
	raycast.cast_to = Vector3(0,-100,0)
	raycast.translation.y = 70
	raycast.enabled = true

func randomly_place_ray():
	randomize()
	raycast.translation.x = rand_range(-740,740)
	raycast.translation.z = rand_range(-740,740)

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

