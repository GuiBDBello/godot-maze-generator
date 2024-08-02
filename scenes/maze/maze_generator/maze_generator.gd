class_name MazeGenerator extends Node3D


func generate_maze(maze: Maze, is_generated_slowly: bool) -> void:
	push_error("UNIMPLEMENTED ERROR: MazeGenerator.generate_maze()")


func center_maze_on_screen(maze_width: int, maze_height: int, maze_wall_length: int) -> void:
	var maze_position_x: int = ((maze_width * maze_wall_length) - maze_wall_length)
	var maze_position_z: int = ((maze_height * maze_wall_length) - maze_wall_length)
	self.set_position(Vector3(-maze_position_x, 0, -maze_position_z))
