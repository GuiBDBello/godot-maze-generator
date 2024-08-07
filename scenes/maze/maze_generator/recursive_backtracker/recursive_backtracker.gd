extends GridBasedMazeGenerator


func generate_maze(maze: Maze, is_generated_slowly: bool) -> void:
	super.center_maze_on_screen(maze.width, maze.height, maze.wall_length)
	
	var maze_grid: Array = await super.generate_cell_grid(maze.width, maze.height, maze.wall_length, maze.wall_height, maze.wall_thickness)
	
	var cell_stack: Array = []
	
	var initial_cell: Node3D = super.randomize_start_position(maze_grid, maze.width, maze.height)
	initial_cell.visit()
	cell_stack.push_back(initial_cell)
	
	while not cell_stack.is_empty():
		var current_cell: Node3D = cell_stack.pop_back()
		var unvisited_neighbours: Array = find_unvisited_neighbours(maze_grid, current_cell)
		
		if not unvisited_neighbours.is_empty():
			cell_stack.push_back(current_cell)
			
			var current_neighbour: Node3D = super.get_random_neighbour_from_array(unvisited_neighbours)
			super.remove_walls_between(current_cell, current_neighbour)
			current_neighbour.visit()
			cell_stack.push_back(current_neighbour)
			
			if is_generated_slowly:
				await get_tree().create_timer(0.05).timeout


func find_unvisited_neighbours(maze_grid: Array, current_cell: Node3D) -> Array:
	var unvisited_neighbours: Array = []
	
	if current_cell.grid_position_x > 0:
		var west_neighbour: Node3D = maze_grid[current_cell.grid_position_x - 1][current_cell.grid_position_y]
		if not west_neighbour.is_visited:
			unvisited_neighbours.push_back(west_neighbour)
	
	if current_cell.grid_position_x < maze_grid.size() - 1:
		var east_neighbour: Node3D = maze_grid[current_cell.grid_position_x + 1][current_cell.grid_position_y]
		if not east_neighbour.is_visited:
			unvisited_neighbours.push_back(east_neighbour)
	
	if current_cell.grid_position_y > 0:
		var north_neighbour: Node3D = maze_grid[current_cell.grid_position_x][current_cell.grid_position_y - 1]
		if not north_neighbour.is_visited:
			unvisited_neighbours.push_back(north_neighbour)
	
	if current_cell.grid_position_y < maze_grid[current_cell.grid_position_x].size() - 1:
		var south_neighbour: Node3D = maze_grid[current_cell.grid_position_x][current_cell.grid_position_y + 1]
		if not south_neighbour.is_visited:
			unvisited_neighbours.push_back(south_neighbour)
		
	return unvisited_neighbours
