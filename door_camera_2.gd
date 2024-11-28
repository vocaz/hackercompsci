extends Node2D
var totalgoals = 5
var currentgoals = 0
signal success
signal failed
var failstate = false
var instruction = []
var label = ''
var time = ''
var timeleft = '%ss'
var signalsent = false
# Called when the node enters the scene tree for the first time.
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds,false).timeout
func _ready() -> void:
	label = $CanvasLayer/Timeleft
	time = $Timer
	$CanvasLayer/Label.visible = false
func send(instruction: Dictionary):
	#Globals.socket.put_packet(message.to_utf8_buffer())
	instruction["role"] = Globals.role
	instruction["version"] = Globals.api_version
	Globals.socket.send_text(JSON.stringify(instruction))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_timeleft()
	if failstate == false:
		if currentgoals == totalgoals:
			if signalsent == false:
				signalsent = true
				emit_signal("success")
	else:
		if signalsent == false:
			signalsent = true
			emit_signal("failed")

func _on_timer_timeout() -> void:
	failstate = true
	
func _on_goalgotten() -> void:
	currentgoals += 1
	print(currentgoals)
	
func _on_success() -> void:
	$CanvasLayer/success.visible = true
	$"CanvasLayer/Green Flash".material.set_shader_parameter("Switch",1.0)
	await wait(0.5)
	$CanvasLayer/success.visible = false
	$"CanvasLayer/Green Flash".material.set_shader_parameter("Switch",0)
	instruction = {"action":"hack", "item":Globals.currenthack, "state":"success"}
	send(instruction)


func _on_failed() -> void:
	$CanvasLayer/timeup.visible = true
	$"CanvasLayer/Red Flash".material.set_shader_parameter("Switch",1.0)
	await wait(0.5)
	$CanvasLayer/timeup.visible = false
	$"CanvasLayer/Red Flash".material.set_shader_parameter("Switch",0)
	instruction = {"action":"hack", "item":Globals.currenthack, "state":"failed"}
	send(instruction)
func update_timeleft():
	label.text = timeleft % [str(ceil(time.time_left))]
