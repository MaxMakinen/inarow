extends Control

class_name Board

const SQUARE = preload("res://square.tscn")


@onready var square_grid: GridContainer = %SquareGrid
@onready var central_grid: MarginContainer = %CentralGrid
@onready var turn: Label = %Turn
@onready var win_len: Label = %WinLen

var grid_size: int
var grid_state: Array
enum {EMPTY, PLAYER_X, PLAYER_O}

var minimax_round = 0
var fbm_finder = 0

func set_grid_size(new_grid_size: int) -> void:
	grid_size = new_grid_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_display_turn()
	_make_clean_grid()
	square_grid.columns = grid_size
	for index in range(grid_size * grid_size):
		var temp_square: Square = SQUARE.instantiate()
		square_grid.add_child(temp_square)
		temp_square.state_changed.connect(_board_change)
	_set_margins()

func _set_margins() -> void:
	var margin_value: int = int((square_grid.get_child(0).size.x * grid_size) / 4)
	central_grid.add_theme_constant_override("margin_top", margin_value)
	central_grid.add_theme_constant_override("margin_left", margin_value)
	central_grid.add_theme_constant_override("margin_bottom", margin_value)
	central_grid.add_theme_constant_override("margin_right", margin_value)

func _make_clean_grid() -> void:
	for index in range(grid_size):
		grid_state.append([])
		for index2 in range(grid_size):
			grid_state[index].append(0)


func _board_change() -> void:
	_display_turn()
	for row in grid_size:
		for col in grid_size:
			grid_state[row][col] = square_grid.get_child(row * grid_size + col).get_state()
	if _check_for_win(grid_state):
		_declare_win()

func _check_for_win(board: Array) -> bool:
	var temp_arr: Array = []
	for index in grid_size:
		temp_arr.clear()
		if _check_array(board[index]) == true:
			return true
		for row in board:
			temp_arr.append(row[index])
		if _check_array(temp_arr) == true:
			return true
		temp_arr = _get_diagonal(index, 1, board)
		if _check_array(temp_arr[0]) == true or _check_array(temp_arr[1]) == true:
			return true
		temp_arr = _get_diagonal(index, -1, board)
		if _check_array(temp_arr[0]) == true or _check_array(temp_arr[1]) == true:
			return true
	return false


func _check_draw() -> bool:
	var empty_squares: Array = []
	for row in range(grid_size):
		for col in range(grid_size):
			if grid_state[row][col] == 0:
				empty_squares.append(0)
	if empty_squares.size() > 0:
		return false
	return true

func _declare_win() -> void:
	get_tree().change_scene_to_file("res://win_screen.tscn")


func _check_array(row: Array) -> bool:
	var win_count: int = 0
	var prev: int = 0
	for col in row:
		if col != 0 and col == prev:
			win_count += 1
			if win_count >= Global.get_win_len() - 1:
				Global.set_winner(col)
				return true
		elif col != prev:
			win_count = 0
		prev = col
	return false


func _get_diagonal(col: int, dir: int, board: Array) -> Array:
	var temp_arr_left: Array = []
	var temp_arr_right: Array = []
	for step in grid_size:
		if col - step >= 0:
			temp_arr_left.append(board[step * dir][col - step])
		else:
			temp_arr_left.append(0)
		if col + step < grid_size:
			temp_arr_right.append(board[step * dir][col + step])
		else:
			temp_arr_right.append(0)
	return [temp_arr_left, temp_arr_right]


func _display_turn() -> void:
	win_len.text = str(Global.get_win_len())
	if Global.get_turn() == 1:
		turn.text = "X"
	else:
		turn.text = "O"

