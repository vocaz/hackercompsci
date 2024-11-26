extends Node2D
var key_event = ""
var letter = ""
var captureon = false
var inputseq = []
const ascii_letters_and_digits = "abcdefghijklmnopqrstuvwxyz1234567890-=`[]\';,./"
func _input(event : InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var key_event := event as InputEventKey
		# filter for printable characters
		var letter := key_event.as_text_key_label().to_lower()#String.chr(key_event.unicode)
		if letter in ascii_letters_and_digits:
			if captureon == true:
				inputseq.append(letter)

func simoncount():
	var message = "Watch the guards inputs closely!"
	$CanvasLayer/Panel/Countdown.text = "[font_size=40][center]%s[/center][/font_size]" % [message]

func genSequence(length: int) -> String:
	var result = []
	for i in range(length):
		result.append(ascii_letters_and_digits[randi() % ascii_letters_and_digits.length()])
	return result
	$"CanvasLayer/Panel/VBoxContainer/HBoxContainer/Player box2/Simon".showSequence(genSequence(8))

func _ready():
	simoncount()
