class_name GridBasedMazeGenerator extends MazeGenerator


const MAZE_CELL: PackedScene = preload("res://scenes/maze/maze_cell.tscn")

var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func generate_cell_grid(width: int, height: int, wall_length: int, wall_height: int, wall_thickness: float) -> Array:
	var grid: Array = []
	for x: int in width:
		grid.append([])
		for y in height:
			var cell: Node3D = MAZE_CELL.instantiate()
			cell.name = str("Maze Cell ", x, "-", y)
			cell.position = Vector3(x * wall_length * 2, 0, y * wall_length * 2)
			cell.grid_position_x = x
			cell.grid_position_y = y
			grid[x].append(cell)
			self.add_child(cell)
			cell.set_wall_sizes(wall_length, wall_height, wall_thickness)
			
	return grid


func randomize_start_position(maze_grid: Array, maze_width: int, maze_height: int) -> Node3D:
	var maze_start_position_width: int = rng.randi_range(0, maze_width - 1)
	var maze_start_position_height: int = rng.randi_range(0, maze_height - 1)
	
	return maze_grid[maze_start_position_width][maze_start_position_height]


func get_neighbours(current_cell: Node3D, maze_grid: Array) -> Array:
	var neighbours: Array = []
	
	if current_cell.grid_position_x > 0:
		neighbours.push_back(maze_grid[current_cell.grid_position_x - 1][current_cell.grid_position_y])
	
	if current_cell.grid_position_x < maze_grid.size() - 1:
		neighbours.push_back(maze_grid[current_cell.grid_position_x + 1][current_cell.grid_position_y])
	
	if current_cell.grid_position_y > 0:
		neighbours.push_back(maze_grid[current_cell.grid_position_x][current_cell.grid_position_y - 1])
	
	if current_cell.grid_position_y < maze_grid[current_cell.grid_position_x].size() - 1:
		neighbours.push_back(maze_grid[current_cell.grid_position_x][current_cell.grid_position_y + 1])
		
	return neighbours


func get_random_neighbour_from_array(cell_neighbours: Array) -> Node3D:
	var neighbour_position: int = rng.randi_range(0, cell_neighbours.size() - 1)
	return cell_neighbours[neighbour_position]


func remove_walls_between(current_cell: Node3D, current_neighbour: Node3D) -> void:
	if current_cell.grid_position_x < current_neighbour.grid_position_x:
		current_cell.wall_east.queue_free()
		current_neighbour.wall_west.queue_free()
		current_neighbour.visit()
		
	if current_cell.grid_position_x > current_neighbour.grid_position_x:
		current_cell.wall_west.queue_free()
		current_neighbour.wall_east.queue_free()
		current_neighbour.visit()
	
	if current_cell.grid_position_y > current_neighbour.grid_position_y:
		current_cell.wall_north.queue_free()
		current_neighbour.wall_south.queue_free()
		current_neighbour.visit()
	
	if current_cell.grid_position_y < current_neighbour.grid_position_y:
		current_cell.wall_south.queue_free()
		current_neighbour.wall_north.queue_free()
		current_neighbour.visit()
