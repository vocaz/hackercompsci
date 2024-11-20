extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func check_goal():
	$RayCast2D.force_raycast_update()
	if $RayCast2D.is_colliding():
		$RayCast2D.get_collider().goal_get()

func go_in_direction(dir):
	var done := false
	while not done:
		check_goal()
		if not move_and_collide(dir*50, true):
			position += dir*50
		else:
			done = true
	check_goal()

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
