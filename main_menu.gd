extends Node2D
var addressvar = []
var connected := false
var addresses = []
var addresslistpopup = ["MAC ADDRESS"]
var closestformat = "%s|This is the device you are next to"
var addressids = []
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
	Globals.currenthack = -1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Globals.socket.poll()

	if Globals.socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while Globals.socket.get_available_packet_count():
			var server_message = Globals.socket.get_packet().get_string_from_ascii()
			var server_response = JSON.new()
			if server_response.parse(server_message) == OK:
				$Panel/Foreground/Hack.set_disabled(true)
				var response = server_response.data
				if response["type"] == "environment":
					var env = response["response"]
					for space in env:
						if space["actions"].has("hack"):
							Globals.currenthack = space["id"]
							print(Globals.currenthack)
							var templateAction = "There is a hackable %s in the %s direction"
							var currentAction = templateAction % [space["type"],space["direction"]]
							print(currentAction)
							$Panel/Foreground/Hack.set_disabled(false)
				if response["type"] == "begin_action":
					addresses = response["data"]
					for address in addresses:
						addressvar = str_to_var(address)
						if addressvar["id"] == Globals.currenthack:
							addresslistpopup.append(closestformat % [addressvar["mac"],])
						else:
							addresslistpopup.append(addressvar["mac"])
						addressids.append(addressvar["id"])
					hacking_popup(addresslistpopup)
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
	var instruction = {"action":"hack", "item":Globals.currenthack, "state":"begin"}
	send(instruction)
	

func hacking_popup(list) -> void:
	for item in list:
		$Panel/PopupMenu.add_item(item,)
	$Panel/PopupMenu.show()

func _on_popup_menu_index_pressed(index: int) -> void:
	Globals.currenthack = addressids[index-1] # Replace with function body.
	print(Globals.currenthack)
