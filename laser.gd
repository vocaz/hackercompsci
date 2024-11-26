extends Node2D
var key_event = ""
var letter = ""
var remcapture = 0
var inputseq = []
var simonseq = []
var iscorrect = true
var incorrect = 0
var finalletter = false
signal readyforcheck
const ascii_letters_and_digits = """ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-=`[]\';,./"""
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds,false).timeout
func _input(event : InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var key_event := event as InputEventKey
		# filter for printable characters
		var letter := key_event.as_text_key_label()#String.chr(key_event.unicode)
		if letter in ascii_letters_and_digits:
			if remcapture == 1:
				finalletter = true
			if remcapture > 0:
				inputseq.append(letter)
				$"CanvasLayer/Panel/VBoxContainer/HBoxContainer/Player box/PlayerInput".text = "[center]%s[/center]" % [letter]
				remcapture -= 1
				if finalletter == true:
					readyforcheck.emit()
		print(letter)	

func simoncount():
	var message = "Watch the guards inputs closely!"
	$CanvasLayer/Panel/Countdown.text = "[font_size=40][center]%s[/center][/font_size]" % [message]
	await wait(0.3)
	message = "3"
	$CanvasLayer/Panel/Countdown.text = "[font_size=40][center]%s[/center][/font_size]" % [message]
	await wait(0.3)
	message = "2"
	$CanvasLayer/Panel/Countdown.text = "[font_size=40][center]%s[/center][/font_size]" % [message]
	await wait(0.3)
	message = "1"
	$CanvasLayer/Panel/Countdown.text = "[font_size=40][center]%s[/center][/font_size]" % [message]
	await wait(0.3)
	$CanvasLayer/Panel/Countdown.text = ""
	simonseq = genSequence(3)
	await $CanvasLayer/Panel/VBoxContainer/HBoxContainer/SimonBox/Simon.showSequence(simonseq)
	message = "Now your turn! Repeat the sequence!"
	$CanvasLayer/Panel/Countdown.text = "[font_size=40][center]%s[/center][/font_size]" % [message]
	remcapture = 3
	
func genSequence(length: int) -> Array:
	var result = []
	for i in range(length):
		result.append(ascii_letters_and_digits[randi() % ascii_letters_and_digits.length()])
	return result
func _ready():
	simoncount()


func _on_readyforcheck() -> void:
	for i in range(0,len(inputseq)):
		if inputseq[i] != simonseq[i]:
			iscorrect = false
			incorrect = i
	if iscorrect == false:
		print("incorrect. you put:")
		print(inputseq[incorrect])
		print("it should've been:")
		print(simonseq[incorrect])
	else:
		print("correct") # Replace with function body.
