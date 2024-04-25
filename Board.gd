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
#	if Global.get_turn() == 2:
#		ai_make_move()
#		if _check_for_win():
#			_declare_win()
##		Global.change_turn()
#		return
	if _check_for_win():
		_declare_win()

func _check_for_win() -> bool:
	var temp_arr: Array = []
	for index in grid_size:
		temp_arr.clear()
		if _check_array(grid_state[index]) == true:
			return true
		for row in grid_state:
			temp_arr.append(row[index])
		if _check_array(temp_arr) == true:
			return true
		temp_arr = _get_diagonal(index, 1)
		if _check_array(temp_arr[0]) == true or _check_array(temp_arr[1]) == true:
			return true
		temp_arr = _get_diagonal(index, -1)
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


func _get_diagonal(col: int, dir: int) -> Array:
	var temp_arr_left: Array = []
	var temp_arr_right: Array = []
	for step in grid_size:
		if col - step >= 0:
			temp_arr_left.append(grid_state[step * dir][col - step])
		else:
			temp_arr_left.append(0)
		if col + step < grid_size:
			temp_arr_right.append(grid_state[step * dir][col + step])
		else:
			temp_arr_right.append(0)
	return [temp_arr_left, temp_arr_right]


func _display_turn() -> void:
	win_len.text = str(Global.get_win_len())
	if Global.get_turn() == 1:
		turn.text = "X"
	else:
		turn.text = "O"


func ai_make_move() -> void:
	#var best_move: Vector2 = minimax(grid_state.duplicate(), PLAYER_O)["move"]
	var best_move: Vector2 = _find_best_move()
	grid_state[best_move.x][best_move.y] = square_grid.get_child(best_move.x * grid_size + best_move.y).set_state()


func minimax(board_state: Array, player: int, depth: int) -> Dictionary:
	if _check_for_win():
		if Global.get_turn() == player:
			return {"score": 10, "move": Vector2(-1, -1)}
		else:
			return {"score": -10, "move": Vector2(-1, -1)}
	if _check_draw():
		return {"score": 0, "move": Vector2(-1, -1)}
	
	var best_score = -1000 if player == PLAYER_O else 1000
	var best_move = null

	for i in range(grid_size):
		for j in range(grid_size):
			if board_state[i][j] == EMPTY:
				board_state[i][j] = player
				var result = minimax(board_state, PLAYER_O if player == PLAYER_X else PLAYER_X, depth + 1)
				board_state[i][j] = EMPTY

				var score = result["score"] 
				if player == PLAYER_O:
					if score > best_score:
						best_score = score
						best_move = Vector2(i, j)
				else:
					if score < best_score:
						best_score = score
						best_move = Vector2(i, j)
	if best_move == null:
		best_move = Vector2(-1, -1)
	return {"score": best_score, "move": best_move}


func _find_best_move() -> Vector2:
	var bestVal: int = -1000
	var bestMove: Vector2 = Vector2(-1, -1)
	
	for row in range(grid_size):
		for col in range(grid_size):
			if grid_state[row][col] == 0:
				# Make move
				grid_state[row][col] = PLAYER_O
				
				# Evaluate move
				var result = minimax(grid_state.duplicate(), PLAYER_O, 0)
				var moveVal = result["score"]
				# Undo move
				grid_state[row][col] = EMPTY
				# If current moveVal is better than bestVal, then update best
				if moveVal > bestVal:
					bestMove = result["move"]
					bestVal = moveVal
	print("Best Move = ", bestMove)
	return bestMove


