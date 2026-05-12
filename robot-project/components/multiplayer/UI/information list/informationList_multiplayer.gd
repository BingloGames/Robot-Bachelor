extends InformationList
class_name MultiplayerInformationList
##Show the list of functions and other information in a multiplayer setting.


func _ready() -> void:
	itemsList = ["forward()", "backward()", "wait()", "left()", "right()", "for i in range(n):"]
	super._ready()


##Reset the items on server/clients.
func restart() -> void:
	restart_multiplayer.rpc()

##RPC that resets the items.
@rpc("call_local")
func restart_multiplayer() -> void:
	super.restart()
	
