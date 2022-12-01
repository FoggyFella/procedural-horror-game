extends Node
class_name RandomlyPlacedObject

export (PackedScene) var object
export (int) var amount_of_object
export (bool) var should_rotate_normal = false
export (NodePath) var where_store
export (Vector3) var min_angle
export (Vector3) var max_angle
var amount = 0
onready var raycast = get_node("RayCast")
var collide_point = null
var normal = null

func _ready():
	setup_raycast()
	randomly_place_ray()
	collide_point = raycast.get_collision_point()
	normal = raycast.get_collision_normal()
	while amount < amount_of_object:
		if raycast.is_colliding():
			collide_point = raycast.get_collision_point()
			normal = raycast.get_collision_normal()
			var object_instance = object.instance()
			if normal < max_angle and normal > min_angle:
				amount += 1
				#for some reason this fucking breaks the rotating on normals
				#get_node(where_store).call_deferred("add_child",object_instance,true)
				add_child(object_instance,true)
				object_instance.global_translation = collide_point
				if should_rotate_normal:
					object_instance.global_transform = align_with_y(object_instance.global_transform, normal)
				randomly_place_ray()
				raycast.force_raycast_update()
			else:
				randomly_place_ray()
				raycast.force_raycast_update()
		else:
			randomly_place_ray()
			raycast.force_raycast_update()
	#self.queue_free()
	$RayCast.queue_free()


func setup_raycast():
	raycast.cast_to = Vector3(0,-100,0)
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

