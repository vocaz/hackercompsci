extends Control

var websocket_url := "ws://10.202.182.8:9876"
var api_version = "1.01"
var client_type = "godot"
var role = "lockpick"

var socket := WebSocketPeer.new()
var connected := false

func send(message: String):
	#socket.put_packet(message.to_utf8_buffer())
	socket.send_text(message)

func log_message(message: String) -> void:
	var time := "%s | " % Time.get_time_string_from_system()
	print(time + message)
func _ready() -> void:
	pass # Replace with function body.

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
