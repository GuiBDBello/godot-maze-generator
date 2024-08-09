extends MazeGenerator


func generate_maze(maze: Maze, is_generated_slowly: bool) -> void:
	super.center_maze_on_screen(maze.width, maze.height, maze.wall_length)
	
	var maze_grid: Array[Array] = super.generate_grid(maze)
	
	var current_cell: MazeCell = super.get_random_cell(maze_grid, maze.width, maze.height)
	current_cell.visit()
	
	var unvisited_cell_amount: int = (maze.width * maze.height) - 1
	while unvisited_cell_amount > 0:
		var current_neighbour: MazeCell = super.find_neighbours(current_cell, maze_grid).pick_random()
		
		if not current_neighbour.is_visited:
			super.remove_walls_between(current_cell, current_neighbour)
			current_neighbour.visit()
			unvisited_cell_amount -= 1
			
			if is_generated_slowly:
				await get_tree().create_timer(0.05).timeout
		
		current_cell = current_neighbour
