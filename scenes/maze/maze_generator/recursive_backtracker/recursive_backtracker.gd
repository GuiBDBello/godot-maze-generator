extends MazeGenerator


func generate_maze(maze: Maze, is_generated_slowly: bool) -> void:
	super.center_maze_on_screen(maze.width, maze.height, maze.wall_length)
	
	var maze_grid: Array[Array] = await super.generate_grid(maze)
	
	var cell_stack: Array[MazeCell] = []
	
	var initial_cell: MazeCell = super.get_random_cell(maze_grid, maze.width, maze.height)
	initial_cell.visit()
	cell_stack.push_back(initial_cell)
	
	while not cell_stack.is_empty():
		var current_cell: MazeCell = cell_stack.pop_back()
		var unvisited_neighbours: Array[MazeCell] = super.find_unvisited_neighbours(maze_grid, current_cell)
		
		if not unvisited_neighbours.is_empty():
			cell_stack.push_back(current_cell)
			
			var current_neighbour: MazeCell = unvisited_neighbours.pick_random()
			super.remove_walls_between(current_cell, current_neighbour)
			current_neighbour.visit()
			cell_stack.push_back(current_neighbour)
			
			if is_generated_slowly:
				await get_tree().create_timer(0.05).timeout
