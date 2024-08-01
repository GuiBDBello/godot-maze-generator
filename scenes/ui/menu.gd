extends Control

@onready var game = $".."
@onready var algorithm_option_button: OptionButton = $"MarginContainerBack/MarginContainer/VBoxContainer/Algorithm OptionButton"
@onready var width_h_slider: HSlider = $"MarginContainerBack/MarginContainer/VBoxContainer/Width HSlider"
@onready var height_h_slider: HSlider = $"MarginContainerBack/MarginContainer/VBoxContainer/Height HSlider"
@onready var wall_length_spin_box: SpinBox = $"MarginContainerBack/MarginContainer/VBoxContainer/Wall Length HBoxContainer/Wall Length SpinBox"
@onready var wall_height_spin_box: SpinBox = $"MarginContainerBack/MarginContainer/VBoxContainer/Wall Height HBoxContainer/Wall Height SpinBox"
@onready var wall_thickness_spin_box: SpinBox = $"MarginContainerBack/MarginContainer/VBoxContainer/Wall Thickness HBoxContainer/Wall Thickness SpinBox"
@onready var generate_slowly_check_button: CheckButton = $"MarginContainerBack/MarginContainer/VBoxContainer/Generate Slowly HBoxContainer/Generate Slowly CheckButton"

var initial_maze_width: int
var initial_maze_height: int
var initial_maze_wall_length: int
var initial_maze_wall_height: int
var initial_maze_wall_thickness: float
var initial_is_generated_slowly: bool

var maze_width: int
var maze_height: int
var maze_wall_length: int
var maze_wall_height: int
var maze_wall_thickness: float
var is_generated_slowly: bool


func _ready() -> void:
	for algorithm : PackedScene in game.maze_generation_algorithms:
		algorithm_option_button.add_item(algorithm._bundled.get("names")[0])

	initial_maze_width = width_h_slider.value
	initial_maze_height = height_h_slider.value
	initial_maze_wall_length = wall_length_spin_box.value
	initial_maze_wall_height = wall_height_spin_box.value
	initial_maze_wall_thickness = wall_thickness_spin_box.value
	initial_is_generated_slowly = generate_slowly_check_button.button_pressed
	
	reset_values()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("reset_values"):
		reset_values()
	if Input.is_action_just_pressed("generate_maze"):
		var maze: Maze = Maze.new_maze(maze_width, maze_height, maze_wall_length, maze_wall_height, maze_wall_thickness)
		await game.generate_maze(maze, is_generated_slowly)
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
	var maze: Maze = Maze.new_maze(maze_width, maze_height, maze_wall_length, maze_wall_height, maze_wall_thickness)
	await game.generate_maze(maze, is_generated_slowly)


func reset_values() -> void:
	maze_width = initial_maze_width
	maze_height = initial_maze_height
	maze_wall_length = initial_maze_wall_length
	maze_wall_height = initial_maze_wall_height
	maze_wall_thickness = initial_maze_wall_thickness
	is_generated_slowly = initial_is_generated_slowly
	
	width_h_slider.value = initial_maze_width
	height_h_slider.value = initial_maze_height
	wall_length_spin_box.value = initial_maze_wall_length
	wall_height_spin_box.value = initial_maze_wall_height
	wall_thickness_spin_box.value = initial_maze_wall_thickness
	generate_slowly_check_button.button_pressed = initial_is_generated_slowly
