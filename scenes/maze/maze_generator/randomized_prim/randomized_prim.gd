extends MazeGenerator

var frontier: Array[MazeCell] = []


func _ready() -> void:
	rng.randomize()


func generate_maze(maze: Maze, is_generated_slowly: bool) -> void:
	super.center_maze_on_screen(maze)
	
	var maze_grid: Array[Array] = super.generate_grid(maze)
	
	# Step 2: Pick a random starting cell and mark it as visited
	var start_cell: MazeCell = super.get_random_cell(maze_grid)
	start_cell.is_visited = true
	
	# Step 3: Add neighbors of the start cell to the frontier
	frontier = super.find_unvisited_neighbours(maze_grid, start_cell)
	
	# Step 4: Iterate while there are frontier cells
	while frontier.size() > 0:
		# Step 4a: Choose a random frontier cell
		var current_cell: MazeCell = frontier[rng.randi_range(0, frontier.size() - 1)]
		frontier.erase(current_cell)
		
		# Step 4b: Find neighbors that are already part of the maze (visited)
		var visited_neighbours: Array[MazeCell] = []
		if current_cell.grid_position_x > 0 and maze_grid[current_cell.grid_position_x - 1][current_cell.grid_position_y].is_visited:
			visited_neighbours.append(maze_grid[current_cell.grid_position_x - 1][current_cell.grid_position_y])
		if current_cell.grid_position_x < maze_grid.size() - 1 and maze_grid[current_cell.grid_position_x + 1][current_cell.grid_position_y].is_visited:
			visited_neighbours.append(maze_grid[current_cell.grid_position_x + 1][current_cell.grid_position_y])
		if current_cell.grid_position_y > 0 and maze_grid[current_cell.grid_position_x][current_cell.grid_position_y - 1].is_visited:
			visited_neighbours.append(maze_grid[current_cell.grid_position_x][current_cell.grid_position_y - 1])
		if current_cell.grid_position_y < maze_grid[current_cell.grid_position_x].size() - 1 and maze_grid[current_cell.grid_position_x][current_cell.grid_position_y + 1].is_visited:
			visited_neighbours.append(maze_grid[current_cell.grid_position_x][current_cell.grid_position_y + 1])

		# Step 4c: Randomly connect the current cell with one of its visited neighbors
		if visited_neighbours.size() > 0:
			var neighbour: MazeCell = visited_neighbours[rng.randi_range(0, visited_neighbours.size() - 1)]
			remove_walls_between(current_cell, neighbour)
			current_cell.is_visited = true

			# Add its unvisited neighbors to the frontier
			var unvisited_neighbours = find_unvisited_neighbours(maze_grid, current_cell)
			for unvisited_neighbour in unvisited_neighbours:
				if not frontier.has(unvisited_neighbour):
					frontier.append(unvisited_neighbour)

		# Optional: Add a small delay if you want to visualize the maze generation step by step
		if is_generated_slowly:
			await get_tree().create_timer(0.05).timeout
