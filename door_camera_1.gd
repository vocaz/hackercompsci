extends Node2D
var totalgoals = 5
var currentgoals = 0
signal done
var failed = false
# Called when the node enters the scene tree for the first time.
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds,false).timeout
func _ready() -> void:
	$CanvasLayer/Label.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if failed == false:
		if currentgoals == totalgoals:
			emit_signal("done")



func _on_timer_timeout() -> void:
	failed = true


func _on_goalgotten() -> void:
	currentgoals += 1
	print(currentgoals)


func _on_done() -> void:
	$CanvasLayer/Label.visible = true
	$"CanvasLayer/Green Flash".material.set_shader_parameter("Switch",1.0)
	await wait(0.5)
	$CanvasLayer/Label.visible = false
	$"CanvasLayer/Green Flash".material.set_shader_parameter("Switch",0)
