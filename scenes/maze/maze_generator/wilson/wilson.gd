extends GridBasedMazeGenerator


func generate_maze(maze: Maze, is_generated_slowly: bool) -> void:
	super.center_maze_on_screen(maze.width, maze.height, maze.wall_length)
	
	var maze_grid: Array = await super.generate_cell_grid(maze.width, maze.height, maze.wall_length, maze.wall_height, maze.wall_thickness)
	
	var unvisited_cells: int = maze.width * maze.height
	
	var initial_cell: MazeCell = super.randomize_start_position(maze_grid, maze.width, maze.height)
	initial_cell.visit()
	unvisited_cells -= 1
	
	while unvisited_cells > 0:
		var current_cell: MazeCell = super.randomize_start_position(maze_grid, maze.width, maze.height)
		while current_cell.is_visited:
			current_cell = super.randomize_start_position(maze_grid, maze.width, maze.height)
		
		var cell_neighbours: Array = super.get_neighbours(current_cell, maze_grid)
		var current_neighbour: MazeCell = super.get_random_neighbour_from_array(cell_neighbours)
		
		var walked_cells: Array[MazeCell] = [current_cell]
		
		while not current_neighbour.is_visited:
			if walked_cells.has(current_neighbour):
				var last_cell: MazeCell = walked_cells[-1]
				while not current_neighbour == last_cell:
					walked_cells.pop_back()
					last_cell = walked_cells[-1]
			else:
				walked_cells.push_back(current_neighbour)
			
			current_cell = current_neighbour
			cell_neighbours = super.get_neighbours(current_cell, maze_grid)
			current_neighbour = super.get_random_neighbour_from_array(cell_neighbours)
		
		walked_cells.push_back(current_neighbour)
		
		for i: int in walked_cells.size() - 1:
			var before_cell = walked_cells[i]
			var after_cell = walked_cells[i + 1]
			super.remove_walls_between(before_cell, after_cell)
			before_cell.visit()
			after_cell.visit()
			unvisited_cells -= 1
