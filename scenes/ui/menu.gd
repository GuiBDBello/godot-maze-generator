extends Control

@onready var game = $".."
@onready var option_button: OptionButton = $MarginContainerBack/MarginContainer/VBoxContainer/OptionButton


var maze_width: int = 5
var maze_height: int = 5
var is_generated_slowly: bool = false


func _ready() -> void:
	for algorithm : PackedScene in game.maze_generation_algorithms:
		option_button.add_item(algorithm._bundled.get("names")[0])


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_menu_visible"):
		self.visible = !self.visible


func _on_option_button_item_focused(index: int) -> void:
	game.change_algorithm(index)


func _on_h_slider_width_value_changed(value):
	self.maze_width = int(value)


func _on_h_slider_height_value_changed(value):
	self.maze_height = int(value)


func _on_generate_slowly_toggled(toggled_on):
	self.is_generated_slowly = toggled_on


func _on_generate_maze_pressed():
	await game.generate_maze(maze_width, maze_height, is_generated_slowly)
