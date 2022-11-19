extends StaticBody

func _ready():
	yield(get_tree(),"idle_frame")
	self.rotation = $RayCast.get_collision_normal()
