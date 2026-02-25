extends Node


const PORT = 3032


var peer = null
var player_name = "Robot"


var players = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	multiplayer.connection_failed.connect(_connection_failed)


func _connection_failed():
	print("failed connection")
	multiplayer.multiplayer_peer = null
	#tell the player that the connection failed


func _player_connected(id):
	register_player.rpc_id(id, player_name)
	if get_node("/root").has_node("2 player menu"):
		get_node("/root/2 player menu/host game/start").disabled = false
	#allow the host to start the game


func _player_disconnected(id):
	players.erase(id)
	#visually remove the disconnected player
	#if the game is ongoing, stop the game



@rpc("any_peer")
func register_player(new_player_name):
	var id = multiplayer.get_remote_sender_id()
	players[id] = new_player_name
	print("player with name: ", new_player_name, " added!")
	#update visually that the player is added


func host_game(new_player_name):
	player_name = new_player_name
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, 2)
	multiplayer.set_multiplayer_peer(peer)


func join_game(ip_address, new_player_name):
	player_name = new_player_name
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, PORT)
	multiplayer.set_multiplayer_peer(peer)
