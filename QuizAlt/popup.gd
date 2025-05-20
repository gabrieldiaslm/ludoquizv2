extends Popup

signal secondary_signal(value: bool)

var question_is_correct: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_main_close_popup() -> void:
	self.queue_free()



func _on_main_question_answer(value: bool) -> void:
	question_is_correct = value
	print("valor da parte 2", question_is_correct)
	emit_signal("secondary_signal", question_is_correct)
