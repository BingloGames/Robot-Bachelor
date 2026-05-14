extends InputPopUp
class_name MultiplayerInputPopUp
##Text window for questions and tasks for levels. 
##It gets the text from a text file automatically, if it exists. 
##Can be used to add questions for buttons.
##Should only be used in a multiplayer setting.


##Players that answered correctly.
var player_correct_answer = []
##Players that answered.
var players_answered = []


##Show self and pauses the game.
func show_input() -> void:
	super.show_input()
	
	
	for robot in code_node.robot_waiting_data:
		code_node.robot_waiting_data[robot]["running_code"] = false


##Marks the client as answered correctly on server/client.
func correct_answer() -> void:
	robot_answer_correct.rpc()

##RPC that marks the sender as answered correctly.
##If all players answered correctly, continues the game and activate the button.
##If at least one player answered wrong, continues the game but does not activate the button.
@rpc("any_peer", "call_local")
func robot_answer_correct() -> void:
	var player_id = multiplayer.get_remote_sender_id()
	if player_id in players_answered:
		return
	
	
	players_answered.append(player_id)
	player_correct_answer.append(player_id)
	
	
	if len(player_correct_answer) == ConnectionController.NUM_PLAYERS:
		success_question()
		
		
		
	elif len(players_answered) == ConnectionController.NUM_PLAYERS:
		if len(players_answered) == ConnectionController.NUM_PLAYERS:
			failed_question()

##Continues the game and activate the button.
func success_question() -> void:
	super.correct_answer()
	
	
	player_correct_answer.clear()
	players_answered.clear()

##Marks the client as answered incorrectly on server/clients.
func wrong_answer() -> void:
	robot_answer_wrong.rpc()

##RPC that marks the sender and answered incorrectly.
@rpc("any_peer", "call_local")
func robot_answer_wrong() -> void:
	var player_id = multiplayer.get_remote_sender_id()
	if player_id in players_answered:
		return
	
	
	players_answered.append(player_id)
	
	
	if len(players_answered) == ConnectionController.NUM_PLAYERS:
		failed_question()

##Continues the game, but does not activate the button.
func failed_question() -> void:
	super.wrong_answer()
	
	
	for robot in code_node.robot_waiting_data:
		code_node.robot_waiting_data[robot]["running_code"] = true
	
	
	player_correct_answer.clear()
	players_answered.clear()
