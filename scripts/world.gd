extends Node3D
@onready var player = $player
@onready var esc_user_option = $EscUserOption
var panels
var EscMenu = false
var hiddenChild = []
func _ready():
	panels = get_tree().get_nodes_in_group("defaultHide")

func _input(_event):
	if Input.is_action_just_pressed("esc"):
		player.on_Esc(true)
		hide_show_all_child()
		if !EscMenu:
			esc_user_option.show()
		else:
			esc_user_option.hide()
		EscMenu = !EscMenu

func hide_show_all_child():
	for child in get_children():
		if child is WorldEnvironment:
			continue
		if !EscMenu:
			child.hide()
		else:
			child.show()


func _on_esc_user_option_rtp(node):
	player.on_Esc(true)
	hide_show_all_child()
	node.hide()
	EscMenu = !EscMenu

func _on_player_die_panel_respawn(node):
	player.on_Esc(true)
	player.reset()
	for child in get_children():
		if child is WorldEnvironment:
			continue
		child.show()
	for i in panels:
		i.hide()
	node.hide()


func _on_player_player_die():
	player.on_Esc(true)
	hide_show_all_child()
	$PlayerDiePanel.show()
