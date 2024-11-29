extends Node2D
var shakestrength = 2
var curshakestrength = 0;
var key_event = ""
var letter = ""
var remcapture = 0
var inputseq = []
var simonseq = []
var iscorrect = true
var incorrect = 0
var instruction = {}
signal readyforcheck
const ascii_letters_and_digits = """ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-=`[]\';,./"""

func send(instruction: Dictionary):
	#Globals.socket.put_packet(message.to_utf8_buffer())
	instruction["role"] = Globals.role
	instruction["version"] = Globals.api_version
	Globals.socket.send_text(JSON.stringify(instruction))

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds,false).timeout
func _input(event : InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var key_event := event as InputEventKey
		# filter for printable characters
		var letter := key_event.as_text_key_label()#String.chr(key_event.unicode)
		match letter:
			"Slash":
				letter = "/"
			"Period":
				letter = "."
			"Comma":
				letter = ","
			"Semicolon":
				letter = ";"
			"Apostrophe":
				letter = "'"
			"BracketLeft":
				letter = "["
			"BracketRight":
				letter = "]"
			"BackSlash":
				letter = "\\"
			"Minus":
				letter = "-"
			"Equal":
				letter = "="
			"QuoteLeft":
				letter = "`"
		if letter in ascii_letters_and_digits:
			if remcapture > 0:
				inputseq.append(letter)
				$"CanvasLayer/Panel/VBoxContainer/HBoxContainer/Player box/PlayerInput".text = "[center]%s[/center]" % [letter]
				remcapture -= 1
				readyforcheck.emit()

func simoncount(length: int):
	var message = "Watch the guards inputs closely!"
	$CanvasLayer/Panel/Countdown.text = "[font_size=40][center]%s[/center][/font_size]" % [message]
	await wait(1)
	message = "3"
	$CanvasLayer/Panel/Countdown.text = "[font_size=40][center]%s[/center][/font_size]" % [message]
	await wait(1)
	message = "2"
	$CanvasLayer/Panel/Countdown.text = "[font_size=40][center]%s[/center][/font_size]" % [message]
	await wait(1)
	message = "1"
	$CanvasLayer/Panel/Countdown.text = "[font_size=40][center]%s[/center][/font_size]" % [message]
	await wait(1)
	$CanvasLayer/Panel/Countdown.text = ""
	simonseq = genSequence(length)
	await $CanvasLayer/Panel/VBoxContainer/HBoxContainer/SimonBox/Simon.showSequence(simonseq)
	message = "Now your turn! Repeat the sequence!"
	$CanvasLayer/Panel/Countdown.text = "[font_size=40][center]%s[/center][/font_size]" % [message]
	remcapture = length
	
func genSequence(length: int) -> Array:
	var result = []
	for i in range(length):
		result.append(ascii_letters_and_digits[randi() % ascii_letters_and_digits.length()])
	return result
func _ready():
	simoncount(5)
func _process(delta):
	curshakestrength = max(curshakestrength - delta,0);

func _on_readyforcheck() -> void:
	for i in range(0,len(inputseq)):
		if inputseq[i] != simonseq[i]:
			iscorrect = false
			incorrect = i
	if iscorrect == false:
		curshakestrength = shakestrength
		$CanvasLayer/ColorRect.material.set_shader_parameter("ShakeStrength",max(curshakestrength,0))
		$CanvasLayer/ColorRect2.material.set_shader_parameter("Switch",1.0)
		await wait (0.2)
		$CanvasLayer/ColorRect2.material.set_shader_parameter("Switch",0)
		$CanvasLayer/ColorRect.material.set_shader_parameter("ShakeStrength",0)
		print("incorrect. you put:")
		print(inputseq[incorrect])
		print("it should've been:")
		print(simonseq[incorrect])
		instruction = {"action":"hack", "item":Globals.currenthack, "state":"failed"}
		send(instruction)
		get_tree().change_scene_to_file("res://Main Menu.tscn")
	else:
		if remcapture == 0:
			print("Full Sequence Correct")
			$"CanvasLayer/Panel/VBoxContainer/Wall/Laser background".visible = false
			$"CanvasLayer/Panel/VBoxContainer/Wall/Laser foreground".visible = false
			$CanvasLayer/Panel/VBoxContainer/Wall/Hacker.position = Vector2(395, 73)
			$"CanvasLayer/Green Flash".material.set_shader_parameter("Switch",1.0)
			$"CanvasLayer/Panel/VBoxContainer/HBoxContainer/success".visible = true
			await wait(0.5)
			instruction = {"action":"hack", "item":Globals.currenthack, "state":"success"}
			send(instruction)
			get_tree().change_scene_to_file("res://Main Menu.tscn")
		else:
			print("letter correct") # Replace with function body.
