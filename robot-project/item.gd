extends Node2D
class_name Item


@export var item_name = "Item"
var itemCollected = false


func _ready() -> void:
	get_node("Label").text = item_name


func respawn() -> void:
	get_node("collect anim").stop()
	get_node("particles").hide()
	get_node("Box").scale = Vector2(0.8, 0.8)
	get_node("Label").modulate.a = 0
	itemCollected = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if itemCollected:
		return
	
	get_node("particles").show()
	get_node("particles").emitting = true
	get_node("collect anim").play("collect")
	itemCollected = true
	
	
	get_parent().new_item(self)
