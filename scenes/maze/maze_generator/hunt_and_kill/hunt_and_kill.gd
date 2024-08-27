extends MazeGenerator

var visited_cells: Array[MazeCell] = []


func _ready() -> void:
	rng.randomize()


func generate_maze(maze: Maze, is_generated_slowly: bool) -> void:
	super.center_maze_on_screen(maze)
	
	var maze_grid: Array[Array] = super.generate_grid(maze)

	var current_cell: MazeCell = super.get_random_cell(maze_grid)
	current_cell.is_visited = true
	visited_cells.append(current_cell)

	while visited_cells.size() < maze.width * maze.height:
		while true:
			var unvisited_neighbours: Array[MazeCell] = super.find_unvisited_neighbours(maze_grid, current_cell)
			if unvisited_neighbours.size() <= 0:
				break
			
			var next_cell: MazeCell = unvisited_neighbours[rng.randi_range(0, unvisited_neighbours.size() - 1)]
			super.remove_walls_between(current_cell, next_cell)
			current_cell = next_cell
			current_cell.is_visited = true
			visited_cells.append(current_cell)
			
			if is_generated_slowly:
				await get_tree().create_timer(0.05).timeout
		
		current_cell = self.hunt_for_next_cell(maze_grid)
		if current_cell != null:
			current_cell.is_visited = true
			visited_cells.append(current_cell)


func hunt_for_next_cell(maze_grid: Array[Array]) -> MazeCell:
	for y: int in range(maze_grid.size()):
		for x: int in range(maze_grid[y].size()):
			var cell: MazeCell = maze_grid[x][y]
			if not cell.is_visited:
				var neighbours: Array[MazeCell] = super.find_neighbours(cell, maze_grid)
				for neighbour: MazeCell in neighbours:
					if neighbour.is_visited:
						super.remove_walls_between(cell, neighbour)
						return cell
	return null


func remove_walls_between(cell1: MazeCell, cell2: MazeCell) -> void:
	if cell1.grid_position_x < cell2.grid_position_x:
		cell1.wall_east.queue_free()
		cell2.wall_west.queue_free()
	elif cell1.grid_position_x > cell2.grid_position_x:
		cell1.wall_west.queue_free()
		cell2.wall_east.queue_free()
	elif cell1.grid_position_y < cell2.grid_position_y:
		cell1.wall_south.queue_free()
		cell2.wall_north.queue_free()
	elif cell1.grid_position_y > cell2.grid_position_y:
		cell1.wall_north.queue_free()
		cell2.wall_south.queue_free()
