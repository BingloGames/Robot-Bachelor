extends Node2D


@onready var anim_player = get_node("AnimationPlayer")
@onready var start_button = get_node("start")
@onready var language_selector = get_node("language selector")


var level_selectors_file_template = "res://{0}_player_menu.tscn"


func _on_start_pressed() -> void:
	anim_player.play("start")
	start_button.set_disabled(true)
	get_node("players/1").set_disabled(false)#does this do anything?
	get_node("players/2").set_disabled(false)


func _on_players_pressed(num_players: String) -> void:
	var level_selector_path = level_selectors_file_template.format([num_players])
	
	
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate:a", 0, 0.5)
	tween.tween_callback(Callable(get_tree(), "change_scene_to_file").bind(level_selector_path)).set_delay(0.2)


func _on_language_selector_item_selected(index: int) -> void:
	var language = language_selector.get_item_text(index)
	
	
	match language:
		"English":
			Global.text_language = "/ENG/"
		"Español":
			Global.text_language = "/ES/"
		"Norsk":
			Global.text_language = "/NO/"
	
	
	#reset the text that is already loaded?
