extends Control

const MAZE_GENERATOR = preload("res://scenes/maze_generator.tscn")

var maze_width = 5
var maze_height = 5
var is_generated_slowly_toggled_on = false

@onready var game = $".."
@onready var maze_generator = $"../Maze Generator"


func _on_generate_maze_pressed():
	maze_generator.queue_free()
	await maze_generator.tree_exited
	maze_generator = MAZE_GENERATOR.instantiate()
	maze_generator.name = "Maze Generator"
	game.add_child(maze_generator)
	maze_generator.generate(self.maze_width, self.maze_height, self.is_generated_slowly_toggled_on)
	game.center_maze_on_screen(self.maze_width, self.maze_height)
	game.calculate_camera_distance(self.maze_width, self.maze_height)


func _on_h_slider_width_value_changed(value):
	self.maze_width = int(value)


func _on_h_slider_height_value_changed(value):
	self.maze_height = int(value)


func _on_generate_slowly_toggled(toggled_on):
	self.is_generated_slowly_toggled_on = toggled_on
