extends CanvasLayer

@onready var rect := $Fade

func fade_in():
	rect.visible = true
	rect.modulate.a = 0.0

	var tween = create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, 0.3)

	await tween.finished


func fade_out():
	rect.modulate.a = 1.0

	var tween = create_tween()
	tween.tween_property(rect, "modulate:a", 0.0, 0.3)

	await tween.finished
