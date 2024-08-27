extends MazeGenerator

var current_run: Array[MazeCell] = []


func _ready() -> void:
	rng.randomize()


func generate_maze(maze: Maze, is_generated_slowly: bool) -> void:
	super.center_maze_on_screen(maze)
	
	var maze_grid: Array[Array] = super.generate_grid(maze)

	for y: int in range(maze.height):
		current_run.clear()

		for x: int in range(maze.width):
			var cell: MazeCell = maze_grid[x][y]
			current_run.append(cell)

			var at_eastern_boundary: bool = (x == maze.width - 1)
			var at_northern_boundary: bool = (y == 0)

			var carve_east: bool = rng.randf() < 0.5

			if not at_eastern_boundary and (carve_east or at_northern_boundary):
				var east_cell: MazeCell = maze_grid[x + 1][y]
				super.remove_walls_between(cell, east_cell)
			else:
				if not at_northern_boundary:
					var random_cell: MazeCell = current_run[rng.randi_range(0, current_run.size() - 1)]
					var north_cell: MazeCell = maze_grid[random_cell.grid_position_x][y - 1]
					super.remove_walls_between(random_cell, north_cell)
				
				current_run.clear()
			
			if is_generated_slowly:
				await get_tree().create_timer(0.05).timeout
