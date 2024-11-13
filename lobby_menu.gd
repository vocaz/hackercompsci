extends Control

var api_version = "1.01"
var client_type = "godot"
var role = "lockpick"

var socket := WebSocketPeer.new()
var connected := false


func send(instruction: Dictionary):
	#socket.put_packet(message.to_utf8_buffer())
	instruction["role"] = role
	instruction["version"] = api_version
	socket.send_text(JSON.stringify(instruction))
	

func log_message(message: String) -> void:
	var time := "%s | " % Time.get_time_string_from_system()
	print(time + message)
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	socket.poll()

	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var server_message = socket.get_parket().get_string_from_ascii()
			var server_response = JSON.new()
			if server_response.parse(server_message) == OK:
				var response = server_response.data
				if response["type"] == "environment":
					log_message("Here is the environment around your character: ")
					print(response["response"])
			log_message(socket.get_packet().get_string_from_ascii())


func _on_button_pressed() -> void:
	Globals.playerName = $Panel/Background/LineEdit.text
	print(Globals.playerName)
	
	Globals.serverIP = $Panel/Background/LineEdit2.text
	print(Globals.serverIP)
	
	var websocket_url := "ws://%s:9876" % [str(Globals.serverIP)]
	print(websocket_url)
	
	if socket.connect_to_url(websocket_url) != OK:
		log_message("Unable to connect.")
		set_process(false)
	else:
		var state = socket.get_ready_state()
		
		while state == WebSocketPeer.STATE_CONNECTING:
			state = socket.get_ready_state() 
			socket.poll()
		connected = true
		#initial connection string - sub "lockpick" for selected role
		var instruction = {"action":"join"}
		send(instruction)
		print("Connected!")
		get_tree().change_scene_to_file("res://Main Menu.tscn")
