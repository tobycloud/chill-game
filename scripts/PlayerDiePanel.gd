extends Control

signal respawn(node)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_respawn_pressed():
	respawn.emit(self)
