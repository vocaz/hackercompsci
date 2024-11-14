extends Node2D

var ascii_letters_and_digits = "abcdefghijklmnopqrstuvwxyz1234567890-=`[]\';,./"

func genSequence(length: int) -> String:
	var result = ""
	for i in range(length):
		result += ascii_letters_and_digits[randi() % ascii_letters_and_digits.length()]
	return result
func _ready():
	for i in range(25):
		print(genSequence(8))
