extends Node2D



var connected := false

func send(instruction: Dictionary):
	#Globals.socket.put_packet(message.to_utf8_buffer())
	instruction["role"] = Globals.role
	instruction["version"] = Globals.api_version
	Globals.socket.send_text(JSON.stringify(instruction))
	
func log_message(message: String) -> void:
	var time := "%s | " % Time.get_time_string_from_system()
	print(time + message)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Globals.socket.poll()

	if Globals.socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while Globals.socket.get_available_packet_count():
			var server_message = Globals.socket.get_packet().get_string_from_ascii()
			var server_response = JSON.new()
			if server_response.parse(server_message) == OK:
				var response = server_response.data
				if response["type"] == "environment":
					log_message("Here is the environment around your character: ")
					print(response["response"])
					
					
			log_message(Globals.socket.get_packet().get_string_from_ascii())

func _on_up_pressed() -> void:
	var instruction = {"action":"move", "direction":"up"}# Replace with function body.
	send(instruction)
	
func _on_right_pressed() -> void:
	var instruction = {"action":"move", "direction":"right"}# Replace with function body.
	send(instruction)# Replace with function body.
	
func _on_down_pressed() -> void:
	var instruction = {"action":"move", "direction":"down"}# Replace with function body.
	send(instruction)# Replace with function body.

func _on_left_pressed() -> void:
	var instruction = {"action":"move", "direction":"left"}# Replace with function body.
	send(instruction)# Replace with function body.

func _on_hack_pressed() -> void:
	
	var instruction = {"action":"hack"}
	send(instruction)
	
