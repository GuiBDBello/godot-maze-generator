extends MazeGenerator

var frontier: Array[MazeCell] = []


func _ready() -> void:
	rng.randomize()


func generate_maze(maze: Maze, is_generated_slowly: bool) -> void:
	super.center_maze_on_screen(maze)

	var maze_grid: Array[Array] = super.generate_grid(maze)

	var start_cell: MazeCell = super.get_random_cell(maze_grid)
	start_cell.is_visited = true

	frontier = super.find_unvisited_neighbours(maze_grid, start_cell)

	while frontier.size() > 0:
		var current_cell: MazeCell = frontier[rng.randi_range(0, frontier.size() - 1)]
		frontier.erase(current_cell)
		
		var visited_neighbours: Array[MazeCell] = []
		if current_cell.grid_position_x > 0 and maze_grid[current_cell.grid_position_x - 1][current_cell.grid_position_y].is_visited:
			visited_neighbours.append(maze_grid[current_cell.grid_position_x - 1][current_cell.grid_position_y])
		if current_cell.grid_position_x < maze_grid.size() - 1 and maze_grid[current_cell.grid_position_x + 1][current_cell.grid_position_y].is_visited:
			visited_neighbours.append(maze_grid[current_cell.grid_position_x + 1][current_cell.grid_position_y])
		if current_cell.grid_position_y > 0 and maze_grid[current_cell.grid_position_x][current_cell.grid_position_y - 1].is_visited:
			visited_neighbours.append(maze_grid[current_cell.grid_position_x][current_cell.grid_position_y - 1])
		if current_cell.grid_position_y < maze_grid[current_cell.grid_position_x].size() - 1 and maze_grid[current_cell.grid_position_x][current_cell.grid_position_y + 1].is_visited:
			visited_neighbours.append(maze_grid[current_cell.grid_position_x][current_cell.grid_position_y + 1])

		if visited_neighbours.size() > 0:
			var neighbour: MazeCell = visited_neighbours[rng.randi_range(0, visited_neighbours.size() - 1)]
			super.remove_walls_between(current_cell, neighbour)
			current_cell.is_visited = true

			var unvisited_neighbours: Array[MazeCell] = super.find_unvisited_neighbours(maze_grid, current_cell)
			for unvisited_neighbour in unvisited_neighbours:
				if not frontier.has(unvisited_neighbour):
					frontier.append(unvisited_neighbour)

		if is_generated_slowly:
			await get_tree().create_timer(0.05).timeout
