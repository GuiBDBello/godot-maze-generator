extends MazeGenerator


const MAZE_WALL: PackedScene = preload("res://scenes/maze/maze_wall.tscn")


func generate_maze(maze: Maze, is_generated_slowly: bool) -> void:
	var wall_list: Array = generate_wall_list(maze.width, maze.height)


func generate_wall_list(width: int, height: int) -> Array:
	var wall_list: Array = []
	
	var maze_size: int = width * height
	for i: int in maze_size:
		var maze_wall = MAZE_WALL.instantiate()
		wall_list.push_back(maze_wall)
	
	return wall_list
