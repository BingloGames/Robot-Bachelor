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
	
	
	ConnectionController.host_game()


func _on_join_pressed() -> void:
	get_node("layer 1").hide()
	get_node("join game").show()


func _on_connect_pressed() -> void:
	var ip_address = get_node("join game/ip address").text
	
	
	if not ip_address.is_valid_ip_address():
		print("invalid ip address")
		# do so the player sees error
		return
	
	
	ConnectionController.join_game(ip_address, ConnectionController.player_name)


func _on_start_pressed() -> void:
	#if multiplayer.is_server():
	move_to_selector.rpc()
	# host goes to level selector


@rpc("call_local", "reliable")
func move_to_selector():
	get_tree().change_scene_to_file("res://2_player_level_selector.tscn")


@rpc("any_peer", "reliable")
func disconnect_peer(id: int):
	multiplayer.multiplayer_peer.disconnect_peer(id)
	get_node("host game/start").disabled = true
	
	
	get_node("host game/Label").text = "No connected robots"


func show_names(new_name):
	var node_path = ""
	
	
	if multiplayer.is_server():
		node_path = "host game/Label"
	else:
		node_path = "joiner connected/Label"
	
	
	get_node(node_path).text = "Fellow robot: \n" + new_name


func _on_cancel_pressed() -> void:
	disconnect_peer.rpc_id(1, multiplayer.get_unique_id())
	
	
	get_node("joiner connected").hide()
	get_node("layer 1").show()


func _on_join_back_pressed() -> void:
	get_node("join game").hide()
	get_node("layer 1").show()


func _on_host_back_pressed() -> void:
	get_node("host game").hide()
	get_node("layer 1").show()
	
	
	ConnectionController.close_game.rpc()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://start_menu.tscn")


func verify_name(player_name: String) -> Array:
	if player_name == "":
		print("you need a name")
		return [false, "You need a name"]
	return [true]


func _on_name_changed(new_text: String) -> void:
	var name_ok = verify_name(new_text)
	var name_valid = name_ok[0]
	
	
	if not name_valid:
		get_node("name error").text = name_ok[1]
		return
	
	
	get_node("name error").text = ""
	print("new player name: ", new_text)
	ConnectionController.player_name = new_text
	
	
	if multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		ConnectionController.new_name.rpc(multiplayer.get_unique_id(), new_text)
