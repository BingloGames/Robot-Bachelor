extends Node2D


var level_selectors_file_template = "res://{0}_player_menu.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_start_pressed() -> void:
	get_node("AnimationPlayer").play("start")
	get_node("start").set_disabled(true)
	get_node("players/1").set_disabled(false)
	get_node("players/2").set_disabled(false)


func _on_players_pressed(num_players: String) -> void:
	var level_selector_path = level_selectors_file_template.format([num_players])
	
	
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate:a", 0, 0.5)
	tween.tween_callback(Callable(get_tree(), "change_scene_to_file").bind(level_selector_path)).set_delay(0.2)
