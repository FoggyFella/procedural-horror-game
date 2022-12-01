extends Spatial

func _ready():
	randomize()
	var number = round(rand_range(1,3))
	get_node("Tree" + str(number)).visible = true
	get_node("Tree" + str(number)).get_node("CollisionShape").disabled = false
	rotation_degrees.y = rand_range(-360,360)
	translation.y -= 2
	scale.x = rand_range(1.7,2.2)
	scale.y = scale.x
	scale.z = scale.x

