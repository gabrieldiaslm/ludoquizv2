extends Control

@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var options: Panel = $Options

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$lobbyOST.play()
	v_box_container.visible = true
	options.visible = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	$buttonclick.play()
	get_tree().change_scene_to_file("res://QuizAlt/tema.tscn")
	print('start')


func _on_settings_pressed() -> void:
	$buttonclick.play()
	print('settings')
	v_box_container.visible = false
	options.visible = true


func _on_credits_pressed() -> void:
	$buttonclick.play()
	print('credits')
	get_tree().change_scene_to_file("res://Scenes/menu/creditos.tscn")



func _on_exit_pressed() -> void:
	$buttonclick.play()
	get_tree().quit()


func _back_pressed() -> void:
	v_box_container.visible = true
	options.visible = false
