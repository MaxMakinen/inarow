extends Control

const BOARD = preload("res://Board.tscn")

@onready var menu_container: PanelContainer = $MenuContainer
@onready var start: Button = $MenuContainer/VBoxContainer/Start
@onready var option_button: OptionButton = $MenuContainer/VBoxContainer/OptionButton


var board: Board = null

func _ready() -> void:
	add_options()


func _on_start_pressed() -> void:
	if board == null:
		board = BOARD.instantiate()
		board.set_grid_size(Global.board_size)
		menu_container.add_sibling(board)
		start.text = "Continue"
	else:
		unpause()
	menu_container.hide()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if board != null and board.visible:
			pause()
		else:
			unpause()


func pause() -> void:
	menu_container.show()
	if board != null:
		board.hide()


func unpause() -> void:
	if board != null:
		menu_container.hide()
		board.show()


func add_options() -> void:
	option_button.add_item("3 in a row")
	option_button.add_item("5 in a row")
	option_button.add_item("7 in a row")
	option_button.add_item("9 in a row")


func _on_option_button_item_selected(index: int) -> void:
	if index == 0:
		Global.set_board_size(5)
		Global.set_win_len(3)
	elif index == 1:
		Global.set_board_size(7)
		Global.set_win_len(5)
	elif index == 2:
		Global.set_board_size(9)
		Global.set_win_len(7)
	elif index == 3:
		Global.set_board_size(11)
		Global.set_win_len(9)


