extends Node

@onready var camera : Camera3D = $"Camera Origin/SpringArm3D/Camera"

const RECURSIVE_BACKTRACKER = preload("res://scenes/maze/recursive_backtracker/recursive_backtracker.tscn")

var maze_generator: Node3D


func generate_maze(maze_width: int, maze_height: int, is_generated_slowly: bool):
	var time_start = Time.get_ticks_msec()
	if maze_generator != null:
		maze_generator.queue_free()
		await maze_generator.tree_exited
	
	maze_generator = RECURSIVE_BACKTRACKER.instantiate()
	maze_generator.name = "Maze Generator"
	self.add_child(maze_generator)
	maze_generator.generate_maze(maze_width, maze_height, is_generated_slowly)
	var time_now = Time.get_ticks_msec()
	var time_elapsed = time_now - time_start
	print(str("Generation Time: ", time_elapsed, "ms"))
