extends Node2D

func _ready():
	$introaudio.play()
	$AnimationPlayer.play("fadein")
	await get_tree().create_timer(2).timeout
	$AnimationPlayer.play("fadeout")
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Scenes/menu/intro2.tscn")
