extends Node
##Handles connection between peers.


##The port the conenction will use
const PORT = 3032
##The number of players
const NUM_PLAYERS = 2

##The peer object of the client.
var peer = null

##The player name.
var player_name = "Robot"
##All of the players ID and their names.
var players = {}
##The players that are ready from the synchronzing to start.
var players_ready_to_sync = []


#change if text file for language support
##The text that show when the connection failed.
var failed_connection_text = "Failed to connect"

##The multiplayer menu scene path.
var multiplayer_start_menu_file = "res://menus/2_player_menu.tscn"


func _ready() -> void:
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	multiplayer.connection_failed.connect(_connection_failed)


func _connection_failed() -> void:
	multiplayer.multiplayer_peer = null
	get_node("/root/2 player menu/join game/error").set_text(failed_connection_text)


func _player_connected(id: int) -> void:
	register_player.rpc_id(id, player_name)
	
	
	if multiplayer.is_server():
		if get_node("/root").has_node("2 player menu"):
			get_node("/root/2 player menu/host game/start").disabled = false
			get_player_name.rpc_id(id, player_name)
	else:
		get_node("/root/2 player menu/join game").hide()
		get_node("/root/2 player menu/joiner connected").show()
		get_player_name.rpc_id(1, player_name)

##RPC that sends the player name.
@rpc("any_peer", "reliable")
func get_player_name(peer_name: String) -> void:
	get_node("/root/2 player menu").show_names(peer_name)

##RPC that update the name of the player with the given ID.
@rpc("any_peer")
func new_name(id: int, new_player_name: String) -> void:
	players[id] = new_player_name
	get_node("/root/2 player menu").show_names(new_player_name)


func _player_disconnected(id: int) -> void:
	players.erase(id)
	print("player disconnected with id: ", id)
	close_game()

##RPC that registers that the sender is connected.
@rpc("any_peer", "reliable")
func register_player(new_player_name: String) -> void:
	var id = multiplayer.get_remote_sender_id()
	players[id] = new_player_name

##Start a server.
func host_game() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, NUM_PLAYERS)
	multiplayer.set_multiplayer_peer(peer)
	players[1] = player_name

##Connect to a server.
func join_game(ip_address: String, new_player_name: String) -> void:
	player_name = new_player_name
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, PORT)
	multiplayer.set_multiplayer_peer(peer)
	players[multiplayer.get_unique_id()] = player_name

##RPC that closes the connection.
@rpc("any_peer", "call_local")
func close_game() -> void:
	players.erase(multiplayer.get_unique_id())
	multiplayer.multiplayer_peer.close()
	
	
	get_tree().change_scene_to_file(multiplayer_start_menu_file)

##RPC that signals that the sender is ready to syncronize.
@rpc("any_peer", "call_local")
func peer_ready_sync() -> void:
	var peer_ready = multiplayer.get_remote_sender_id()
	if peer_ready in players_ready_to_sync:
		return
	
	
	players_ready_to_sync.append(peer_ready)
	
	
	if multiplayer.is_server():
		start_sync.rpc()

##RPC that can only be called from the server. Starts the syncronization.
@rpc("call_local")
func start_sync() -> void:
	if len(players_ready_to_sync) == NUM_PLAYERS:
		for sync in get_tree().get_nodes_in_group("synchronizers"):
			sync.set_visibility_public(true)
		
		
		if get_node("/root/Node2D").has_node("lasers"):
			for laser in get_node("/root/Node2D/lasers").get_children():
				laser._multiplayer_ready()
		
		
		players_ready_to_sync.clear()
		
