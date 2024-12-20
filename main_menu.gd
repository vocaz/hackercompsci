extends Node2D
var templateAction = "There is a hackable %s in the %s direction"
var env
var server_response
var server_message
var response
var addressvar = []
var connected := false
var addresses = []
var addresslistpopup = ["MAC ADDRESS"]
var closestformat = "%s|This is the device you are next to"
var addressids = []
var addressminigame = []
var currentminigame = -1
var numberofmaps = 2
var mazeselect = "res://doorCamera%s.tscn"
var gameselect = 0
func send(instruction: Dictionary):
    #Globals.socket.put_packet(message.to_utf8_buffer())
    instruction["role"] = Globals.role
    instruction["version"] = Globals.api_version
    Globals.socket.send_text(JSON.stringify(instruction))
    
func get_random_maze():
    mazeselect = mazeselect % [randi_range(1,numberofmaps)]
func log_message(message: String) -> void:
    var time := "%s | " % Time.get_time_string_from_system()
    print(time + message)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    _on_left_pressed()
    Globals.currenthack = -1

func recievemessage() -> void:
    Globals.socket.poll()

    if Globals.socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
        while Globals.socket.get_available_packet_count():
            server_message = Globals.socket.get_packet().get_string_from_ascii()
            server_response = JSON.new()
            if server_response.parse(server_message) == OK:
                $Panel/Foreground/Hack.set_disabled(true)
                response = server_response.data
                if response["type"] == "environment":
                    env = response["response"]
                    for space in env:
                        if space["actions"].has("hack"):
                            Globals.currenthack = space["id"]
                            print(Globals.currenthack)
                            var currentAction = templateAction % [space["type"],space["direction"]]
                            print(currentAction)
                            $Panel/Foreground/Hack.set_disabled(false)
                if response["type"] == "begin_action":
                    addresses = response["data"]
                    print(addresses)
                    for address in addresses:
                        print(address)
                        addressvar = address
                        if addressvar["id"] == Globals.currenthack:
                            addresslistpopup.append(closestformat % [addressvar["mac"],])
                        else:
                            addresslistpopup.append(addressvar["mac"])
                        addressids.append(addressvar["id"])
                        addressminigame.append(addressvar["hack_type"])
                    hacking_popup(addresslistpopup)
            log_message(Globals.socket.get_packet().get_string_from_ascii())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    recievemessage()
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
    await recievemessage()
    var instruction = {"action":"hack", "item":Globals.currenthack, "state":"begin"}
    send(instruction)
    
func hacking_popup(list) -> void:
    for item in list:
        $Panel/PopupMenu.add_item(item,)
    $Panel/PopupMenu.show()

func _on_popup_menu_index_pressed(index: int) -> void:
    Globals.currenthack = addressids[index-1] # Replace with function body.
    gameselect = randi_range(1,2)
    currentminigame = addressminigame[index-1]
    print(Globals.currenthack)
    print(currentminigame)
    if gameselect == 1:
        get_random_maze()
        get_tree().change_scene_to_file(mazeselect)
    elif gameselect == 2:
        get_tree().change_scene_to_file("res://laser.tscn")
