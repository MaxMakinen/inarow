extends Node

# Board size and state
var board_size: int = 5
var grid_size: int
var grid_state: Array

var player_turn: int = 1
var winner: String = ""
var win_len = 3
const P1_COLOR: Color = Color.FIREBRICK
const P2_COLOR: Color = Color.DARK_GREEN


func get_grid_size() -> int:
	return grid_size

func set_grid_size(new_size: int) -> void:
	grid_size = new_size


func get_grid_state() -> Array:
	return grid_state

func set_grid_state(new_state: Array) -> void:
	grid_state = new_state


func set_winner(win_int: int) -> void:
	if win_int == 1:
		winner = "X"
	elif win_int == 2:
		winner = "O"
	else:
		winner = "Y"


func get_winner() -> String:
	return winner


func change_turn() -> void:
	if player_turn != 1:
		player_turn = 1
	elif player_turn != 2:
		player_turn = 2


func get_turn() -> int:
	return player_turn


func set_board_size(size: int) -> void:
	board_size = size


func set_win_len(new_win_len: int) -> void:
	win_len = new_win_len


func get_win_len() -> int:
	return win_len


func get_color() -> Color:
	if player_turn == 1:
		return P1_COLOR
	elif player_turn == 2:
		return P2_COLOR
	else:
		return Color.WHITE
