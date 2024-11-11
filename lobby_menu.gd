extends Control
var websocket_url := "ws://127.0.0.1:9876"

var socket := WebSocketPeer.new()

var connected := false

func send(message: String):
	#socket.put_packet(message.to_utf8_buffer())
	socket.send_text(message)
func log_message(message: String) -> void:
	var time := "[color=#aaaaaa] %s |[/color] " % Time.get_time_string_from_system()
	print(time + message)
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	socket.poll()

	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
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
		send("join|lockpick")
		print("Connected!")
