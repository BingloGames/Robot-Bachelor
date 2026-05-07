extends Area2D
class_name RobotButton
##An area that will open doors when a robot object enters it. 
##Can optionally have the player answer a question first, but needs an Input pop up object to be in the sceen tree


##Color of the button. Support red and blue.
@export_enum("red", "blue") var color: String = "blue"
##The doors that will be affected by the button.
@export var doors: Array[NodePath]
##If true, the doors will close when the robot exits the button.
@export var needs_holding: bool = false
##If true, the player have to answer a question before doors opens. 
##This needs an Input pop up object in the sceen tree and the question is decided in that Input pop up.
##Currently only one question is supported in a single level. 
##If you have multiple questions in the same level, it may cause unexpected behaviour..
@export var question = false


func _ready() -> void:
	var sprite = "res://"+color+" button.png"
	get_node("Sprite2D").texture = load(sprite)


func _on_body_entered(body: Node2D) -> void:
	if not body is Robot:
		return
	activate()

##Shows the question if question is true, or opens the doors if question is false.
func activate() -> void:
	print("activate button singleplayer")
	if question:
		for door in doors:
			get_node("/root/Node2D/Input pop up").doors.append(get_node(door))
		get_node("/root/Node2D/Input pop up").show_input()
	else:
		for door in doors:
			get_node(door).open()


func _on_body_exited(body: Node2D) -> void:
	if not body is Robot:
		return
	deactivate()

##If needs_holding is true, the doors closes. Does not do anything if needs_holding is false.
func deactivate() -> void:
	if not needs_holding:
		return
	for door in doors:
		get_node(door).close()
