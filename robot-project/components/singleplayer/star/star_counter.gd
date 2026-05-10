extends Control
class_name StarCounter
##Keeps track and shows how many stars have been picked up.

##Path to the special tile map layer.
@onready var special_tilemap = get_node("/root/Node2D/special")
##The HBoxContainer child of this node.
@onready var container = get_node("HBoxContainer")

##Counts how many stars have been picked up.
var star_count = 0
##Sprite of a full star.
var full_star = preload("res://components/singleplayer/star/star full.png")
##Sprite of an empty star.
var empty_star = preload("res://components/singleplayer/star/star empty.png")

##List of stars collected.
var stars_collected = []

##Resets count and list of picked up stars, makes the picked up stars reapear.
func restart_stars() -> void:
	star_count = 0
	for star_index in stars_collected:
		var star = special_tilemap.get_child(star_index)
		star.respawn()
	
	for star_sprite_parent in container.get_children():
		star_sprite_parent.get_child(0).texture = empty_star
	
	stars_collected.clear()

##Adds the picked up star to the count, list and Star Counter.
func new_star(star_index: int) -> void:
	stars_collected.append(star_index)
	star_count += 1
	container.get_node(str(star_count)+"/Sprite2D").texture = full_star

##Saves the number of picked up stars when a level is compleated.
func save_stars() -> void:
	Global.save_stars(star_count)
