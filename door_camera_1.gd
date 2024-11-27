extends Node2D
var totalgoals = 5
var currentgoals = 0
signal done
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currentgoals == totalgoals:
		pass



func _on_timer_timeout() -> void:
	#var instruction = 
	pass # Replace with function body.


func _on_goalgotten() -> void:
	currentgoals += 1
