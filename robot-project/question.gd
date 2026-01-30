extends Control


var hover_1 = false
var hover_2 = false


var holding_1 = false
var holding_2 = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if holding_1:
		get_node("var_picked_up1").global_position = get_global_mouse_position()
	elif holding_2:
		get_node("var_picked_up2").global_position = get_global_mouse_position()
	
	
	if not Input.is_action_pressed("ui_accept"): #YES THIS IS BAD, I KNOW!
		holding_1 = false
		holding_2 = false
		return
	if hover_1:
		holding_1 = true
		print("holding 1")
	elif hover_2:
		holding_2 = true




func _on_var_picked_up_1_mouse_entered() -> void:
	print("mouse entered 1")
	if holding_2:
		return
	
	print("hover 1")
	hover_1 = true


func _on_var_picked_up_2_mouse_entered() -> void:
	if holding_1:
		return
	
	
	hover_2 = true
