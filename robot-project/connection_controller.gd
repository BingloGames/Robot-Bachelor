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
	
	
	players[0] = players


func _connection_failed():
	print("failed connection")
	multiplayer.multiplayer_peer = null
	#tell the player that the connection failed


func _player_connected(id):
	print("player connected")
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
	print("A job well done!")


@rpc("any_peer")
func new_name(id: int, new_player_name: String):
	players[id] = new_player_name
	get_node("/root/2 player menu").show_names(new_player_name)


func _player_disconnected(id):
	players.erase(id)
	print("player disconnected with id: ", id)
	#if the game is ongoing, stop the game



@rpc("any_peer")
func register_player(new_player_name):
	var id = multiplayer.get_remote_sender_id()
	players[id] = new_player_name
	print("player with name: ", new_player_name, " added!")
	#update visually that the player is added


func host_game():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, 2)
	multiplayer.set_multiplayer_peer(peer)
	player_name[1] = player_name


func join_game(ip_address, new_player_name):
	player_name = new_player_name
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, PORT)
	multiplayer.set_multiplayer_peer(peer)


@rpc("any_peer")
func close_game():
	multiplayer.multiplayer_peer.disconnect_peer(multiplayer.get_unique_id())
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	players.erase(multiplayer.get_unique_id())
	
	
	get_tree().change_scene_to_file("res://2_player_menu.tscn")
