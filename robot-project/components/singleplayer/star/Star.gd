extends Node2D
class_name Star


@onready var anim_player = get_node("AnimationPlayer")
@onready var sprite = get_node("Star")
@onready var star_counter = get_node("/root/Node2D/star counter")


var collected = false


func respawn() -> void:
	anim_player.stop()
	scale = Vector2(1,1)
	sprite.position = Vector2(0,0)
	sprite.scale = Vector2(0.6,0.6)
	collected = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body is Robot:
		return
	if collected:
		return
	
	
	var index = get_index()
	
	
	star_counter.new_star(index)
	anim_player.play("collect")
	collected = true
