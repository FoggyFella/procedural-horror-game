extends Area

func _on_Area_body_entered(body):
	body.die()
	get_tree().paused = true
