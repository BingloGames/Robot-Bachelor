extends Node2D

var collected = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func respawn():
	get_node("AnimationPlayer").stop()
	show()
	scale = Vector2(1,1)
	get_node("Star").position = Vector2(0,0)
	get_node("Star").scale = Vector2(1,1)
	collected = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if collected:
		return
	
	
	get_node("/root/Node2D/star counter").new_star()
	get_node("AnimationPlayer").play("collect")
	collected = true
