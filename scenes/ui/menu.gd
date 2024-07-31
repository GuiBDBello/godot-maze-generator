extends Control

@onready var game = $".."
@onready var option_button: OptionButton = $MarginContainerBack/MarginContainer/VBoxContainer/OptionButton

var maze_width: int = 5
var maze_height: int = 5
var maze_wall_length: int = 1
var maze_wall_height: int = 1
var maze_wall_thickness: float = 0.2
var is_generated_slowly: bool = false


func _ready() -> void:
	for algorithm : PackedScene in game.maze_generation_algorithms:
		option_button.add_item(algorithm._bundled.get("names")[0])


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("generate_maze"):
		await game.generate_maze(maze_width, maze_height, is_generated_slowly)
	if Input.is_action_just_pressed("toggle_menu_visible"):
		self.visible = !self.visible


func _on_option_button_item_focused(index: int) -> void:
	game.change_algorithm(index)


func _on_h_slider_width_value_changed(value: int) -> void:
	self.maze_width = value


func _on_h_slider_height_value_changed(value: int) -> void:
	self.maze_height = value


func _on_wall_length_spin_box_value_changed(value: int) -> void:
	self.maze_wall_length = value


func _on_wall_height_spin_box_value_changed(value: int) -> void:
	self.maze_wall_height = value


func _on_wall_thickness_spin_box_value_changed(value: float) -> void:
	self.maze_wall_thickness = value


func _on_generate_slowly_toggled(toggled_on: bool) -> void:
	self.is_generated_slowly = toggled_on


func _on_generate_maze_pressed() -> void:
	await game.generate_maze(maze_width, maze_height, maze_wall_length, maze_wall_height, maze_wall_thickness, is_generated_slowly)
