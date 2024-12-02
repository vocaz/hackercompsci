extends Control


var connected := false


func send(instruction: Dictionary):
    #Globals.socket.put_packet(message.to_utf8_buffer())
    instruction["role"] = Globals.role
    instruction["version"] = Globals.api_version
    Globals.socket.send_text(JSON.stringify(instruction))
    

func log_message(message: String) -> void:
    var time := "%s | " % Time.get_time_string_from_system()
    print(time + message)
func _ready() -> void:
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    Globals.socket.poll()

    if Globals.socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
        while Globals.socket.get_available_packet_count():
            var server_message = Globals.socket.get_parket().get_string_from_ascii()
            var server_response = JSON.new()
            if server_response.parse(server_message) == OK:
                var response = server_response.data
                if response["type"] == "environment":
                    log_message("Here is the environment around your character: ")
                    print(response["response"])
            log_message(Globals.socket.get_packet().get_string_from_ascii())


func _on_button_pressed() -> void:
    Globals.playerName = $Panel/Background/LineEdit.text
    print(Globals.playerName)
    
    Globals.serverIP = $Panel/Background/LineEdit2.text
    print(Globals.serverIP)
    
    var websocket_url := "ws://%s:9876" % [str(Globals.serverIP)]
    print(websocket_url)
    
    if Globals.socket.connect_to_url(websocket_url) != OK:
        log_message("Unable to connect.")
        set_process(false)
    else:
        var state = Globals.socket.get_ready_state()
        
        while state == WebSocketPeer.STATE_CONNECTING:
            state = Globals.socket.get_ready_state() 
            Globals.socket.poll()
        connected = true
        #initial connection string - sub "lockpick" for selected Globals.role
        var instruction = {"action":"join"}
        send(instruction)
        print("Connected!")
        get_tree().change_scene_to_file("res://Main Menu.tscn")
