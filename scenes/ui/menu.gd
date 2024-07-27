extends Control

@onready var game = $".."

var maze_width: int = 5
var maze_height: int = 5
var is_generated_slowly: bool = false

func _on_generate_maze_pressed():
	
	await game.generate_maze(maze_width, maze_height, is_generated_slowly)
	

func _on_h_slider_width_value_changed(value):
	self.maze_width = int(value)


func _on_h_slider_height_value_changed(value):
	self.maze_height = int(value)


func _on_generate_slowly_toggled(toggled_on):
	self.is_generated_slowly = toggled_on
