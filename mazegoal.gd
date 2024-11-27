extends Area2D
var gotten = false


# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func area_entered(body: Node2D) -> void:
	pass

func goal_get():
	if not gotten:	
		$Sprite2D.texture = load("res://textures/goal green.png")
		gotten = true
		get_tree().call_group("goal", "_on_goalgotten")
