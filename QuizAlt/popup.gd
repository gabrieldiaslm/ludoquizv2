extends Popup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_main_close_popup() -> void:
	self.queue_free()
