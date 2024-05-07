extends Node

@onready var maze_generator = $"Maze Generator"

func _ready():
	calculate_camera_distance()

func calculate_camera_distance():
	maze_generator.position.x -= maze_generator.maze_width / 2
	maze_generator.position.z -= maze_generator.maze_depth / 2
