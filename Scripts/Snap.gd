extends KinematicBody

var player = null
var velocity = Vector3.ZERO

func _ready():
	player = Global.player
	
func _physics_process(delta):
	if player != null:
		var direction_to_player = Global.player.global_translation - self.global_translation
		direction_to_player = direction_to_player.normalized()
		#velocity = direction_to_player
		look_at(player.translation,Vector3.UP)
		#move_and_slide(velocity*20,Vector3.UP)


func _on_Timer_timeout():
	player.slow_death()


func _on_VisibilityNotifier_camera_entered(camera):
	if camera.name == "Player_Camera":
		$Timer.start()


func _on_VisibilityNotifier_camera_exited(camera):
	if camera.name == "Player_Camera":
		$Timer.stop()
