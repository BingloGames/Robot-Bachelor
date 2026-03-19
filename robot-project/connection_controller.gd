extends Node


const PORT = 3032


var peer = null


var player_name = "Robot"
var players = {}

#change if text file for language support
var failed_connection_text = "Failed to connect"


var players_ready_to_sync = []


func _ready() -> void:
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	multiplayer.connection_failed.connect(_connection_failed)


func _connection_failed():
	print("failed connection")
	multiplayer.multiplayer_peer = null
	get_node("/root/2 player menu/join game/error").set_text(failed_connection_text)


func _player_connected(id):
	print("player connected and player name is: ", player_name)
	register_player.rpc_id(id, player_name)
	
	
	if multiplayer.is_server():
		if get_node("/root").has_node("2 player menu"):
			get_node("/root/2 player menu/host game/start").disabled = false
			get_player_name.rpc_id(id, player_name)
	else:
		get_node("/root/2 player menu/join game").hide()
		get_node("/root/2 player menu/joiner connected").show()
		get_player_name.rpc_id(1, player_name)


@rpc("any_peer", "reliable")
func get_player_name(peer_name: String):
	var node_path = ""
	
	
	if multiplayer.is_server():
		node_path = "/root/2 player menu/host game/Label"
	else:
		node_path = "/root/2 player menu/joiner connected/Label"
	
	
	get_node(node_path).text = "Fellow robot: \n" + peer_name


@rpc("any_peer")
func new_name(id: int, new_player_name: String):
	players[id] = new_player_name
	get_node("/root/2 player menu").show_names(new_player_name)


func _player_disconnected(id):
	players.erase(id)
	print("player disconnected with id: ", id)
	close_game()


@rpc("any_peer", "reliable")
func register_player(new_player_name):
	var id = multiplayer.get_remote_sender_id()
	players[id] = new_player_name
	print("player with name: ", new_player_name, " added!")


func host_game():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, 2)
	multiplayer.set_multiplayer_peer(peer)
	players[1] = player_name


func join_game(ip_address, new_player_name):
	player_name = new_player_name
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, PORT)
	multiplayer.set_multiplayer_peer(peer)
	players[multiplayer.get_unique_id()] = player_name


@rpc("any_peer", "call_local")
func close_game():
	players.erase(multiplayer.get_unique_id())
	multiplayer.multiplayer_peer.close()
	
	
	get_tree().change_scene_to_file("res://2_player_menu.tscn")


@rpc("any_peer", "call_local")
func peer_ready_sync():
	print("peer is ready to start synching")
	var peer_ready = multiplayer.get_remote_sender_id()
	if peer_ready in players_ready_to_sync:
		return
	
	
	players_ready_to_sync.append(peer_ready)
	
	
	if multiplayer.is_server():
		start_sync.rpc()


@rpc("call_local")
func start_sync():
	print("try to start the game")
	if len(players_ready_to_sync) == 2:
		for sync in get_tree().get_nodes_in_group("synchronizers"):
			sync.set_visibility_public(true)
		
		
		players_ready_to_sync.clear()
