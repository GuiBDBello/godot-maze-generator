extends MazeGenerator


func generate_maze(maze: Maze, is_generated_slowly: bool) -> void:
	super.center_maze_on_screen(maze)
	
	var maze_grid: Array[Array] = super.generate_grid(maze)
	
	var unvisited_cell_amount: int = maze.width * maze.height
	
	var initial_cell: MazeCell = super.get_random_cell(maze_grid)
	initial_cell.visit()
	unvisited_cell_amount -= 1
	
	while unvisited_cell_amount > 0:
		var current_cell: MazeCell = super.get_random_cell(maze_grid)
		while current_cell.is_visited:
			current_cell = super.get_random_cell(maze_grid)
		
		var cell_neighbours: Array = super.find_neighbours(current_cell, maze_grid)
		var current_neighbour: MazeCell = cell_neighbours.pick_random()
		
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
			cell_neighbours = super.find_neighbours(current_cell, maze_grid)
			current_neighbour = cell_neighbours.pick_random()
		
		walked_cells.push_back(current_neighbour)
		
		for i: int in walked_cells.size() - 1:
			if is_generated_slowly:
				await get_tree().create_timer(0.05).timeout
			
			var before_cell = walked_cells[i]
			var after_cell = walked_cells[i + 1]
			super.remove_walls_between(before_cell, after_cell)
			before_cell.visit()
			after_cell.visit()
			unvisited_cell_amount -= 1
