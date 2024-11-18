extends RichTextLabel
var seq = ["s","d","v"]
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func showSequence(sequence):
	for i in range(0,len(sequence)):
		print(i)
		set_text(str(sequence[i]))
		wait(5)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	showSequence(seq)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
