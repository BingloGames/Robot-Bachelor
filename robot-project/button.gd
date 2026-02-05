extends Area2D


@export var door: NodePath
@export var needs_holding: bool = false


func _on_body_entered(body: Node2D) -> void:
	get_node(door).open()


func _on_body_exited(body: Node2D) -> void:
	if not needs_holding:
		return
	get_node(door).close()
