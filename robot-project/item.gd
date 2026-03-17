extends Node2D
class_name Item


@export var item_name = "Item"
var item_collected = false


func _ready() -> void:
	get_node("Label").text = item_name


func respawn() -> void:
	get_node("collect anim").stop()
	get_node("particles").hide()
	get_node("Box").scale = Vector2(0.8, 0.8)
	get_node("Label").modulate.a = 0
	item_collected = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body is Robot:
		return
	if item_collected:
		return
	
	get_node("particles").show()
	get_node("particles").emitting = true
	get_node("collect anim").play("collect")
	item_collected = true
	
	
	get_parent().new_item(self.get_path())
