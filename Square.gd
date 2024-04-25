extends Control

class_name Square

@onready var border: ColorRect = $Border
@onready var state_label: Label = $MarginContainer/Panel/StateLabel


const STATE: Array = ["", "X", "O"]

var state_int: int = 0
var highlighted: bool = false
var clicked: bool = false
var color: Color

signal state_changed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_label.text = STATE[state_int]


func _on_panel_mouse_entered() -> void:
	print("enter")
	if clicked == false:
		color = Global.get_color()
		border.modulate = color
		border.show()
	highlighted = true


func _on_panel_mouse_exited() -> void:
	print("ecit")
	border.hide()
	border.modulate = Color.WHITE
	highlighted = false


func _input(event: InputEvent) -> void:
	if highlighted == true:
		if event.is_action_released("left_click"):
			if clicked == false:
				_set_state()
				border.hide()
				Global.change_turn()
				state_changed.emit()
			if clicked == true:
				# TODO : Add effect for invalid move
				pass

func _set_state() -> void:
	clicked = true
	state_label.modulate = color
	state_label.text = STATE[Global.get_turn()]

func get_state() -> int:
	return state_int

