extends Node2D
class_name Star
##In game collectible.

##The animation player child of this node.
@onready var anim_player = get_node("AnimationPlayer")
##The sprite child of this node.
@onready var sprite = get_node("Star")
##Path to the Star Counter node.
@onready var star_counter = get_node("/root/Node2D/star counter")

##If the Star has been collected or not
var collected = false

##Makes the star reapear if the level is restarted.
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
