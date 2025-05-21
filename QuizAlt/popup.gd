extends Popup

signal valor_enviado(value)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_main_close_popup(resposta):
	print('VALOR DA RESPOSTA = ', resposta)
	GameManager.valor_da_resposta = resposta
	self.queue_free()


func _on_main_question_correct(value: bool) -> void:
	var question_is_correct = value
	print("valor da parte 2 ", question_is_correct)
	emit_signal("valor_enviado", question_is_correct)
