extends Popup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# No script do seu pop-up (Popup.gd)

func reset_popup():
	# Reinicie todas as variáveis e estados aqui
	$LineEdit.text = ""
	$CheckButton.button_pressed = false
	# Outros resets necessários...

func _on_about_to_show():
	reset_popup()
