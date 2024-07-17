extends Node

@onready var camera : Camera3D = $"Camera Origin/SpringArm3D/Camera"

const RD_FS_RECURSIVE = preload("res://scenes/rd_fs_recursive.tscn")

var maze_generator: Node3D


func generate_maze(maze_width: int, maze_height: int, is_generated_slowly: bool):
	if maze_generator != null:
		maze_generator.queue_free()
		await maze_generator.tree_exited
	
	maze_generator = RD_FS_RECURSIVE.instantiate()
	maze_generator.name = "Maze Generator"
	self.add_child(maze_generator)
	maze_generator.generate_maze(maze_width, maze_height, is_generated_slowly)
