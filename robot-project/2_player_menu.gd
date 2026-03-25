extends Node2D


@onready var host_or_join_node = get_node("host or join")
@onready var host_node = get_node("host game")
@onready var join_node = get_node("join game")
@onready var join_connected = get_node("joiner connected")
@onready var name_error_node = get_node("name error")


var start_menu_file = "res://start_menu.tscn"
var level_selector = "res://2_player_level_selector.tscn"


#change with text file for language support
var invalid_ip_text = "Invalid IP address"
var IP_addresses_text = "Your IP addresses"
var not_connected_text = "No connected robots"
var other_player_connected_text = "Fellow robot"
var need_name_error_text = "You need a name"


func _ready() -> void:
	Global.num_players = "2"


func _on_host_pressed() -> void:
	host_node.show()
	host_or_join_node.hide()
	
	
	var interfaces = IP.get_local_interfaces()
	for interface in interfaces:
		if not (interface["friendly"] == "Wi-Fi" or interface["friendly"] == "Ethernet"):
			continue
		
		
		var temp_text = IP_addresses_text + ": \n"
		for address in interface["addresses"]:
			temp_text += address + "\n"
		
		
		host_node.get_node("ip address").text = temp_text
	ConnectionController.host_game()


func _on_join_pressed() -> void:
	host_or_join_node.hide()
	join_node.show()


func _on_connect_pressed() -> void:
	var ip_address = join_node.get_node("ip address").text
	
	
	if ip_address == "":
		ip_address = "127.0.0.1"
	
	
	if not ip_address.is_valid_ip_address():
		print("invalid ip address")
		join_node.get_node("error").set_text(invalid_ip_text)
		return
	
	
	ConnectionController.join_game(ip_address, ConnectionController.player_name)


func _on_start_pressed() -> void:
	move_to_selector.rpc()


@rpc("call_local", "reliable")
func move_to_selector():
	get_tree().change_scene_to_file(level_selector)


@rpc("any_peer", "reliable")
func disconnect_peer(id: int):
	multiplayer.multiplayer_peer.disconnect_peer(id)
	host_node.get_node("start").disabled = true
	
	
	host_node.get_node("Label").text = not_connected_text


func show_names(new_name):
	var node_path = ""
	
	
	if multiplayer.is_server():
		node_path = "host game/Label"
	else:
		node_path = "joiner connected/Label"
	
	
	get_node(node_path).text = other_player_connected_text + ": \n" + new_name


func _on_cancel_pressed() -> void:
	disconnect_peer.rpc_id(1, multiplayer.get_unique_id())
	
	
	join_connected.hide()
	host_or_join_node.show()


func _on_join_back_pressed() -> void:
	join_node.hide()
	host_or_join_node.show()


func _on_host_back_pressed() -> void:
	host_node.hide()
	host_or_join_node.show()
	
	
	ConnectionController.close_game.rpc()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(start_menu_file)


func verify_name(player_name: String) -> Array:
	if player_name == "":
		return [false, need_name_error_text]
	return [true]


func _on_name_changed(new_text: String) -> void:
	var name_ok = verify_name(new_text)
	var name_valid = name_ok[0]
	
	
	if not name_valid:
		name_error_node.text = name_ok[1]
		return
	
	
	name_error_node.text = ""
	print("new player name: ", new_text)
	ConnectionController.player_name = new_text
	
	
	if multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		ConnectionController.new_name.rpc(multiplayer.get_unique_id(), new_text)
