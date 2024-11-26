extends Node2D
var key_event = ""
var letter = ""
var captureon = false
var inputseq = []
var simonseq = []
var iscorrect = true
var incorrect = 0
const ascii_letters_and_digits = "abcdefghijklmnopqrstuvwxyz1234567890-=`[]\';,./"
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds,false).timeout
func _input(event : InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var key_event := event as InputEventKey
		# filter for printable characters
		var letter := key_event.as_text_key_label().to_lower()#String.chr(key_event.unicode)
		if letter in ascii_letters_and_digits:
			if captureon == true:
				inputseq.append(letter)
			print(letter)

func simoncount():
	var message = "Watch the guards inputs closely!"
	$CanvasLayer/Panel/Countdown.text = "[font_size=40][center]%s[/center][/font_size]" % [message]
	await wait(0.5)
	message = "3"
	$CanvasLayer/Panel/Countdown.text = "[font_size=40][center]%s[/center][/font_size]" % [message]
	await wait(0.5)
	message = "2"
	$CanvasLayer/Panel/Countdown.text = "[font_size=40][center]%s[/center][/font_size]" % [message]
	await wait(0.5)
	message = "1"
	$CanvasLayer/Panel/Countdown.text = "[font_size=40][center]%s[/center][/font_size]" % [message]
	await wait(0.5)
	$CanvasLayer/Panel/Countdown.text = ""
	simonseq = genSequence(5)
	$"CanvasLayer/Panel/VBoxContainer/HBoxContainer/Player box2/Simon".showSequence(simonseq)
	message = "Now your turn! Repeat the sequence!"
	$CanvasLayer/Panel/Countdown.text = "[font_size=40][center]%s[/center][/font_size]" % [message]
	while len(inputseq) < 5:
		captureon = true
	captureon = false
	for i in range(0,len(inputseq)):
		if inputseq[i] != simonseq[i]:
			iscorrect = false
			incorrect = i
	if iscorrect == false:
		print("incorrect")
	else:
		print("correct")
func genSequence(length: int) -> Array:
	var result = []
	for i in range(length):
		result.append(ascii_letters_and_digits[randi() % ascii_letters_and_digits.length()])
	return result

func _ready():
	simoncount()
