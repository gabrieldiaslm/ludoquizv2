extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func pressed_variados() -> void:
	$buttonclick.play()
	GameManager.theme = GameManager.temas_variados
	get_tree().change_scene_to_file("res://Levels/Level_MainGameplay.tscn")

func pressed_historia() -> void:
	$buttonclick.play()
	GameManager.theme = GameManager.temas_historia
	get_tree().change_scene_to_file("res://Levels/Level_MainGameplay.tscn")

func pressed_bio() -> void:
	$buttonclick.play()
	GameManager.theme = GameManager.temas_bio
	get_tree().change_scene_to_file("res://Levels/Level_MainGameplay.tscn")
