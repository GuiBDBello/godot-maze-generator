extends Control

var maze_width = 5
var maze_height = 5
var is_generated_slowly_toggled_on = false

@onready var game = $".."


func _on_generate_maze_pressed():
	pass


func _on_h_slider_width_value_changed(value):
	self.maze_width = int(value)


func _on_h_slider_height_value_changed(value):
	self.maze_height = int(value)


func _on_generate_slowly_toggled(toggled_on):
	self.is_generated_slowly_toggled_on = toggled_on
