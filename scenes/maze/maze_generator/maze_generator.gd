class_name MazeGenerator extends Node3D


const MAZE_CELL: PackedScene = preload("res://scenes/maze/maze_cell.tscn")

var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func generate_maze(maze: Maze, is_generated_slowly: bool) -> void:
	push_error("UNIMPLEMENTED ERROR: MazeGenerator.generate_maze()")


func center_maze_on_screen(maze_width: int, maze_height: int, maze_wall_length: int) -> void:
	var maze_position_x: int = ((maze_width * maze_wall_length) - maze_wall_length)
	var maze_position_z: int = ((maze_height * maze_wall_length) - maze_wall_length)
	self.set_position(Vector3(-maze_position_x, 0, -maze_position_z))


func generate_grid(maze: Maze) -> Array[Array]:
	var maze_grid: Array[Array] = []
	for x: int in maze.width:
		maze_grid.append([])
		for y in maze.height:
			var cell: MazeCell = MAZE_CELL.instantiate()
			cell.name = str("Maze Cell ", x, "-", y)
			cell.position = Vector3(x * maze.wall_length * 2, 0, y * maze.wall_length * 2)
			cell.grid_position_x = x
			cell.grid_position_y = y
			maze_grid[x].append(cell)
			self.add_child(cell)
			cell.set_wall_sizes(maze.wall_length, maze.wall_height, maze.wall_thickness)
			
	return maze_grid


func get_random_cell(maze_grid: Array[Array], maze_width: int, maze_height: int) -> MazeCell:
	var cell_x_axis: int = rng.randi_range(0, maze_width - 1)
	var cell_y_axis: int = rng.randi_range(0, maze_height - 1)
	
	return maze_grid[cell_x_axis][cell_y_axis]


func find_neighbours(current_cell: MazeCell, maze_grid: Array[Array]) -> Array[MazeCell]:
	var neighbours: Array[MazeCell] = []
	
	if current_cell.grid_position_x > 0:
		neighbours.push_back(maze_grid[current_cell.grid_position_x - 1][current_cell.grid_position_y])
	
	if current_cell.grid_position_x < maze_grid.size() - 1:
		neighbours.push_back(maze_grid[current_cell.grid_position_x + 1][current_cell.grid_position_y])
	
	if current_cell.grid_position_y > 0:
		neighbours.push_back(maze_grid[current_cell.grid_position_x][current_cell.grid_position_y - 1])
	
	if current_cell.grid_position_y < maze_grid[current_cell.grid_position_x].size() - 1:
		neighbours.push_back(maze_grid[current_cell.grid_position_x][current_cell.grid_position_y + 1])
		
	return neighbours


func find_unvisited_neighbours(maze_grid: Array[Array], current_cell: MazeCell) -> Array[MazeCell]:
	var unvisited_neighbours: Array[MazeCell] = []
	
	if current_cell.grid_position_x > 0:
		var west_neighbour: MazeCell = maze_grid[current_cell.grid_position_x - 1][current_cell.grid_position_y]
		if not west_neighbour.is_visited:
			unvisited_neighbours.push_back(west_neighbour)
	
	if current_cell.grid_position_x < maze_grid.size() - 1:
		var east_neighbour: MazeCell = maze_grid[current_cell.grid_position_x + 1][current_cell.grid_position_y]
		if not east_neighbour.is_visited:
			unvisited_neighbours.push_back(east_neighbour)
	
	if current_cell.grid_position_y > 0:
		var north_neighbour: MazeCell = maze_grid[current_cell.grid_position_x][current_cell.grid_position_y - 1]
		if not north_neighbour.is_visited:
			unvisited_neighbours.push_back(north_neighbour)
	
	if current_cell.grid_position_y < maze_grid[current_cell.grid_position_x].size() - 1:
		var south_neighbour: MazeCell = maze_grid[current_cell.grid_position_x][current_cell.grid_position_y + 1]
		if not south_neighbour.is_visited:
			unvisited_neighbours.push_back(south_neighbour)
		
	return unvisited_neighbours


func remove_walls_between(current_cell: MazeCell, current_neighbour: MazeCell) -> void:
	if current_cell.grid_position_x < current_neighbour.grid_position_x:
		current_cell.wall_east.queue_free()
		current_neighbour.wall_west.queue_free()
		
	if current_cell.grid_position_x > current_neighbour.grid_position_x:
		current_cell.wall_west.queue_free()
		current_neighbour.wall_east.queue_free()
	
	if current_cell.grid_position_y > current_neighbour.grid_position_y:
		current_cell.wall_north.queue_free()
		current_neighbour.wall_south.queue_free()
	
	if current_cell.grid_position_y < current_neighbour.grid_position_y:
		current_cell.wall_south.queue_free()
		current_neighbour.wall_north.queue_free()
