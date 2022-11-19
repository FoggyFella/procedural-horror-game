extends Spatial

func _ready():
	Global.terrain.connect("trees_placed",self,"on_treesplaced")
	randomize()
	var number = round(rand_range(1,3))
	get_node("Tree" + str(number)).visible = true
	get_node("Tree" + str(number)).get_node("CollisionShape").disabled = false
	rotation_degrees.y = rand_range(-360,360)
	scale.x = rand_range(0.8,1)
	scale.y = scale.x
	scale.z = scale.x
	
func on_treesplaced():
	$DetectOther.monitoring = true
#	var overlappers = $DetectOther.get_overlapping_areas()
#	for overlapper in overlappers:
#		overlapper.get_parent.queue_free()
	


func _on_DetectOther_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	area.get_parent().queue_free()
