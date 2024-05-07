extends Node

@onready var maze_generator = $"Maze Generator"
@onready var camera = $Camera

var width
var depth

func _ready():
	width = maze_generator.maze_width
	depth = maze_generator.maze_depth
	
	center_maze_on_screen()
	calculate_camera_distance()

func center_maze_on_screen():
	maze_generator.position.x -= width / 2
	maze_generator.position.z -= depth / 2

func calculate_camera_distance():
	var maze_length = width if width > depth else depth
	camera.position.y = maze_length if maze_length > 10 else 10
