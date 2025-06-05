extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$credits.play()
	
# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed_credits() -> void:
	$buttonclick.play()
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")
