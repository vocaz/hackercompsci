extends Node2D
var key_event = ""
var letter = ""
func _input(event : InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var key_event := event as InputEventKey
		# filter for printable characters
		if !(key_event.keycode & KEY_SPECIAL):
			var letter := String.chr(key_event.unicode)
			# or on non-control nodes: 
	print(key_event)
var ascii_letters_and_digits = "abcdefghijklmnopqrstuvwxyz1234567890-=`[]\';,./"


func genSequence(length: int) -> String:
	var result = ""
	for i in range(length):
		result += ascii_letters_and_digits[randi() % ascii_letters_and_digits.length()]
	return result
func _ready():
	$Panel/RichTextLabel.showSequence(genSequence(8))
	
