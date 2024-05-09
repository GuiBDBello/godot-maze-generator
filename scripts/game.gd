extends Node


@onready var camera = $"Camera Origin/SpringArm3D/Camera"


func _ready():
	var width = 5
	var depth = 5
	var is_generated_slowly = true
	
	get_maze_generator().generate(width, depth, is_generated_slowly)
	center_maze_on_screen(width, depth)


func center_maze_on_screen(maze_width, maze_depth):
	get_maze_generator().position.x = 0 - (maze_width / 2)
	get_maze_generator().position.z = 0 - (maze_depth / 2)


func get_maze_generator():
	return get_node("./Maze Generator")
