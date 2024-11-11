extends Node2D

var socket := WebSocketPeer.new()

var connected := false
func send(message: String):
	#socket.put_packet(message.to_utf8_buffer())
	socket.send_text(message)
	
func log_message(message: String) -> void:
	var time := "[color=#aaaaaa] %s |[/color] " % Time.get_time_string_from_system()
	print(time + message)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	socket.poll()

	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			log_message(socket.get_packet().get_string_from_ascii())
