class_name Maze extends Node3D

var width: int
var height: int
var wall_length: int
var wall_height: int
var wall_thickness: float

static func new_maze(width: int, height: int, wall_length: int, wall_height: int, wall_thickness: float) -> Maze:
	var maze: Maze = Maze.new()
	maze.width = width
	maze.height = height
	maze.wall_length = wall_length
	maze.wall_height = wall_height
	maze.wall_thickness = wall_thickness
	return maze
