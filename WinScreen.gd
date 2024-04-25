extends PanelContainer


@onready var winner: Label = $MarginContainer/VBoxContainer/Winner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	winner.text = Global.get_winner()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_menu.tscn")

