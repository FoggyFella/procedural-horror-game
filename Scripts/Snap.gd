extends KinematicBody

var player = null
var velocity = Vector3.ZERO

func _ready():
	player = Global.player
	
func _physics_process(delta):
	if player != null:
		var direction_to_player = Global.player.global_translation - self.global_translation
		direction_to_player = direction_to_player.normalized()
		velocity = direction_to_player
		move_and_slide(velocity*10,Vector3.UP)
