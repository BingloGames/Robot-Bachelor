extends Node


const PORT = 3032
const NUM_PLAYERS = 2


var peer = null


var player_name = "Robot"
var players = {}
var players_ready_to_sync = []


#change if text file for language support
var failed_connection_text = "Failed to connect"


var multiplayer_start_menu_file = "res://2_player_menu.tscn"


func _ready() -> void:
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	multiplayer.connection_failed.connect(_connection_failed)


func _connection_failed() -> void:
	print("failed connection")
	multiplayer.multiplayer_peer = null
	get_node("/root/2 player menu/join game/error").set_text(failed_connection_text)


func _player_connected(id: int) -> void:
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
func get_player_name(peer_name: String) -> void:
	get_node("/root/2 player menu").show_names(peer_name)


@rpc("any_peer")
func new_name(id: int, new_player_name: String) -> void:
	players[id] = new_player_name
	get_node("/root/2 player menu").show_names(new_player_name)


func _player_disconnected(id: int) -> void:
	players.erase(id)
	print("player disconnected with id: ", id)
	close_game()


@rpc("any_peer", "reliable")
func register_player(new_player_name: String) -> void:
	var id = multiplayer.get_remote_sender_id()
	players[id] = new_player_name
	print("player with name: ", new_player_name, " added!")


func host_game() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, NUM_PLAYERS)
	multiplayer.set_multiplayer_peer(peer)
	players[1] = player_name


func join_game(ip_address: String, new_player_name: String) -> void:
	player_name = new_player_name
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, PORT)
	multiplayer.set_multiplayer_peer(peer)
	players[multiplayer.get_unique_id()] = player_name


@rpc("any_peer", "call_local")
func close_game() -> void:
	players.erase(multiplayer.get_unique_id())
	multiplayer.multiplayer_peer.close()
	
	
	get_tree().change_scene_to_file(multiplayer_start_menu_file)


@rpc("any_peer", "call_local")
func peer_ready_sync() -> void:
	print("peer is ready to start synching")
	var peer_ready = multiplayer.get_remote_sender_id()
	if peer_ready in players_ready_to_sync:
		return
	
	
	players_ready_to_sync.append(peer_ready)
	
	
	if multiplayer.is_server():
		start_sync.rpc()


@rpc("call_local")
func start_sync() -> void:
	print("try to start the game")
	if len(players_ready_to_sync) == NUM_PLAYERS:
		for sync in get_tree().get_nodes_in_group("synchronizers"):
			sync.set_visibility_public(true)
		
		
		players_ready_to_sync.clear()
