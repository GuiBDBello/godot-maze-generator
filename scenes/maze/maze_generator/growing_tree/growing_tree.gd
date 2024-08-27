extends MazeGenerator

var active_cells: Array[MazeCell] = []


func _ready() -> void:
	rng.randomize()


func generate_maze(maze: Maze, is_generated_slowly: bool) -> void:
	super.center_maze_on_screen(maze)

	var maze_grid: Array[Array] = super.generate_grid(maze)

	var current_cell: MazeCell = super.get_random_cell(maze_grid)
	current_cell.is_visited = true
	active_cells.append(current_cell)

	while active_cells.size() > 0:
		var chosen_cell: MazeCell = self.select_cell()

		var unvisited_neighbours: Array[MazeCell] = super.find_unvisited_neighbours(maze_grid, chosen_cell)

		if unvisited_neighbours.size() > 0:
			var next_cell: MazeCell = unvisited_neighbours[rng.randi_range(0, unvisited_neighbours.size() - 1)]
			super.remove_walls_between(chosen_cell, next_cell)
			next_cell.is_visited = true
			active_cells.append(next_cell)
			
			if is_generated_slowly:
				await get_tree().create_timer(0.05).timeout
		else:
			active_cells.erase(chosen_cell)


func select_cell() -> MazeCell:
	return active_cells[rng.randi_range(0, active_cells.size() - 1)]


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
