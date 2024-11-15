extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func go_in_direction(dir):
	var done := false
	while not done:
		if not move_and_collide(dir*50, true):
			position += dir*50
		else:
			done = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		go_in_direction(Vector2.LEFT)
	if Input.is_action_just_pressed("right"):
		go_in_direction(Vector2.RIGHT)
	if Input.is_action_just_pressed("up"):
		go_in_direction(Vector2.UP)
	if Input.is_action_just_pressed("down"):
		go_in_direction(Vector2.DOWN)
