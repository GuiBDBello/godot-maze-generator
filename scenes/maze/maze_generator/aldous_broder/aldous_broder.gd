extends GridBasedMazeGenerator


func generate_maze(maze: Maze, is_generated_slowly: bool) -> void:
	super.center_maze_on_screen(maze.width, maze.height, maze.wall_length)
	
	var maze_grid: Array = await super.generate_cell_grid(maze.width, maze.height, maze.wall_length, maze.wall_height, maze.wall_thickness)
	
	var current_cell: Node3D = super.randomize_start_position(maze_grid, maze.width, maze.height)
	current_cell.visit()
	
	var unvisited_cells = (maze.width * maze.height) - 1
	while unvisited_cells > 0:
		var current_neighbour: Node3D = super.get_random_neighbour(get_neighbours(current_cell, maze_grid))
		
		if not current_neighbour.is_visited:
			super.remove_walls_between(current_cell, current_neighbour)
			current_neighbour.visit()
			unvisited_cells -= 1
			
			if is_generated_slowly:
				await get_tree().create_timer(0.05).timeout
		
		current_cell = current_neighbour


func get_neighbours(current_cell: Node3D, maze_grid: Array) -> Array:
	var neighbours: Array = []
	
	if current_cell.grid_position_x > 0:
		neighbours.push_back(maze_grid[current_cell.grid_position_x - 1][current_cell.grid_position_y])
	
	if current_cell.grid_position_x < maze_grid.size() - 1:
		neighbours.push_back(maze_grid[current_cell.grid_position_x + 1][current_cell.grid_position_y])
	
	if current_cell.grid_position_y > 0:
		neighbours.push_back(maze_grid[current_cell.grid_position_x][current_cell.grid_position_y - 1])
	
	if current_cell.grid_position_y < maze_grid[current_cell.grid_position_x].size() - 1:
		neighbours.push_back(maze_grid[current_cell.grid_position_x][current_cell.grid_position_y + 1])
		
	return neighbours
