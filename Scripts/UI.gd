extends Control

onready var arrow = $TextureRect
onready var sprite_3d = $"../../../../Sprite3D"
onready var player = $"../../.."

func _process(delta):
	var point = get_parent().unproject_position(sprite_3d.translation)
