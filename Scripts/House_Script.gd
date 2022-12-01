extends StaticBody

func _ready():
	$RayCast.force_raycast_update()
	var collision_point = $RayCast.get_collision_point()
	var normal = $RayCast.get_collision_normal()
	self.global_translation = collision_point
	self.global_transform = align_with_y(global_transform,normal)
	$RayCast.enabled = false

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
