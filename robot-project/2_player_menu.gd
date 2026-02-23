extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_host_pressed() -> void:
	get_node("host game").show()
	get_node("layer 1").hide()
	
	var interfaces = IP.get_local_interfaces()
	
	for interface in interfaces:
		if not interface["friendly"] == "Wi-Fi":
			continue
		
		
		print("Wi-Fi address: ", interface["addresses"])
		
		
		var temp_text = "Your IP addresses: \n"
		for address in interface["addresses"]:
			temp_text += address + "\n"
		
		
		#temp_text = temp_text.left(-1)
		get_node("host game/ip address").text = temp_text


func _on_join_pressed() -> void:
	get_node("layer 1").hide()
	get_node("join game").show()


func _on_connect_pressed() -> void:
	pass
	#try connecting using given ip address


func _on_start_pressed() -> void:
	pass
	# host goes to level selector


func _on_cancel_pressed() -> void:
	pass
	#cancel connection


func _on_join_back_pressed() -> void:
	get_node("join game").hide()
	get_node("layer 1").show()


func _on_host_back_pressed() -> void:
	get_node("host game").hide()
	get_node("layer 1").show()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://start_menu.tscn")
