extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_host_pressed() -> void:
	get_node("host game").show()
	get_node("layer 1").hide()
	
	var interfaces = IP.get_local_interfaces()
	
	
	for interface in interfaces:
		if not (interface["friendly"] == "Wi-Fi" or interface["friendly"] == "Ethernet"):
			continue
		
		
		#print("address: ", interface["addresses"])
		var temp_text = "Your IP addresses: \n"
		for address in interface["addresses"]:
			temp_text += address + "\n"
		
		
		get_node("host game/ip address").text = temp_text
	
	
	var player_name = get_node("name selector").text
	if player_name == "":
		print("you need a name")
		# do so the player sees error
		return
	
	
	ConnectionController.host_game(player_name)


func _on_join_pressed() -> void:
	get_node("layer 1").hide()
	get_node("join game").show()


func _on_connect_pressed() -> void:
	var ip_address = get_node("join game/ip address").text
	var player_name = get_node("name selector").text
	
	
	if player_name == "":
		print("you need a name")
		# do so the player sees error
		return
	
	
	if not ip_address.is_valid_ip_address():
		print("invalid ip address")
		# do so the player sees error
		return
	
	
	ConnectionController.join_game(ip_address, player_name)


func _on_start_pressed() -> void:
	if multiplayer.is_server():
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


func _on_name_changed(new_text: String) -> void:
	pass
	#if player is connected, change name if it is valid
