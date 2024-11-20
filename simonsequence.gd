extends RichTextLabel
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds,false).timeout

func showSequence(sequence):
	for i in sequence:
		set_text("[center]%s[/center]" % [str(i)])
		await wait(1)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
