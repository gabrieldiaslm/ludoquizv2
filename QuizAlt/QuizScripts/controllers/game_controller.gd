extends Node

signal question_answer(value: bool)
signal close_popup()
@export var quiz: QuizTheme
@export var color_right: Color
@export var color_wrong:Color


var target_node = null
var buttons: Array[Button]
var index: int
var correct: int
var current_quiz : QuizQuestion:
	get: return quiz.theme[index]
	
	
@onready var question_texts:Label = $Content/QuestionInfo/QuestionText
@onready var question_image: TextureRect = $Content/QuestionInfo/ImageHolder/QuestionImage


func _ready() -> void:
	for button in $Content/QuestionHolder.get_children():
		buttons.append(button)
	load_quiz()
	
func load_quiz() -> void:
	#randomizar a pergunta
	var QuizSize = len(quiz.theme)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	index = rng.randi_range(0, QuizSize - 1)
	
	print(index,' ', current_quiz.question_info)
	
	#dar as opções nos botões
	question_texts.text = current_quiz.question_info
	var options = current_quiz.options
	
	for i in buttons.size():
		buttons[i].text = options[i]
		buttons[i].pressed.connect(_buttons_asnwer.bind(buttons[i]))
	
	match current_quiz.type:
		Enum.QuestionType.TEXT:
			$Content/QuestionInfo/ImageHolder.hide()
			
		Enum.QuestionType.IMAGE:
			$Content/QuestionInfo/ImageHolder.show()
			question_image.texture = current_quiz.question_image
			

#resposta dos botões
func _buttons_asnwer(button) -> void:
	if current_quiz.correct == button.text:
		button.modulate = color_right
		emit_signal("question_answer", true)
		$AudioCorrect.play()
		
		
	else:
		button.modulate = color_wrong
		emit_signal("question_answer", false)
		$AudioIncorrect.play()
	_next_question()
	
func _end_question() -> void: #voltar pro tabuleiro
	pass
	
func _next_question() -> void: #função do quiz normal do tutorial
	for bt in buttons:
		bt.pressed.disconnect(_buttons_asnwer)
		
	await get_tree().create_timer(1).timeout
	for bt in buttons:
		bt.modulate = Color.WHITE
	if target_node:
		target_node.handle_popup_data($LineEdit.text)
	emit_signal("close_popup")
	
	
