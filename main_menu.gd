extends Node2D

var websocket_url := "ws://10.202.182.8:9876"
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
# Called when the node enters the scene tree for the first time.
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

func _on_up_pressed() -> void:
	var instruction = {"action":"move", "direction":"up"}# Replace with function body.
	send(instruction)
	print(instruction)


func _on_right_pressed() -> void:
	var instruction = {"action":"move", "direction":"right"}# Replace with function body.
	send(instruction)# Replace with function body.
	print(instruction)

func _on_down_pressed() -> void:
	var instruction = {"action":"move", "direction":"down"}# Replace with function body.
	send(instruction)# Replace with function body.
	print(instruction)
	

func _on_left_pressed() -> void:
	var instruction = {"action":"move", "direction":"left"}# Replace with function body.
	send(instruction)# Replace with function body.
	print(instruction)
