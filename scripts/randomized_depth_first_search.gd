extends Node3D

@export var maze_wall_length: int = 2

const MAZE_CELL = preload("res://scenes/maze_cell.tscn")


func generate_maze(maze_width: int, maze_height: int, is_generated_slowly: bool) -> void:
	center_maze_on_screen(maze_width, maze_height, maze_wall_length)
	
	var maze_grid = await generate_grid(maze_width, maze_height)
	
	var cell_stack = []
	var initial_cell = randomize_start_position(maze_grid, maze_width, maze_height)
	initial_cell.visit()
	cell_stack.push_back(initial_cell)
	
	while not cell_stack.is_empty():
		var current_cell = cell_stack.pop_back()
		var unvisited_neighbours = find_unvisited_neighbours(maze_grid, current_cell)
		
		if not unvisited_neighbours.is_empty():
			cell_stack.push_back(current_cell)
			var current_neighbour = get_random_neighbour(unvisited_neighbours)
			remove_walls_between(current_cell, current_neighbour)
			current_neighbour.visit()
			cell_stack.push_back(current_neighbour)
			if is_generated_slowly:
				await get_tree().create_timer(0.05).timeout


func generate_grid(width: int, height: int) -> Array:
	var grid = []
	for x in width:
		grid.append([])
		for y in height:
			var cell = MAZE_CELL.instantiate()
			cell.name = str("Maze Cell ", x, "-", y)
			cell.position = Vector3(x * maze_wall_length, 0, y * maze_wall_length)
			cell.grid_position_x = x
			cell.grid_position_y = y
			grid[x].append(cell)
			self.add_child(cell)
			
	return grid


func randomize_start_position(maze_grid: Array, maze_width: int, maze_height: int) -> Node3D:
	var rng = RandomNumberGenerator.new()
	var maze_start_position_width = rng.randi_range(0, maze_width - 1)
	var maze_start_position_height = rng.randi_range(0, maze_height - 1)
	
	return maze_grid[maze_start_position_width][maze_start_position_height]


func find_unvisited_neighbours(maze_grid: Array, current_cell: Node3D) -> Array:
	var unvisited_neighbours = []
	
	if current_cell.grid_position_x > 0:
		var west_neighbour = maze_grid[current_cell.grid_position_x - 1][current_cell.grid_position_y]
		if not west_neighbour.is_visited:
			unvisited_neighbours.push_back(west_neighbour)
	
	if current_cell.grid_position_x < maze_grid.size() - 1:
		var east_neighbour = maze_grid[current_cell.grid_position_x + 1][current_cell.grid_position_y]
		if not east_neighbour.is_visited:
			unvisited_neighbours.push_back(east_neighbour)
	
	if current_cell.grid_position_y > 0:
		var north_neighbour = maze_grid[current_cell.grid_position_x][current_cell.grid_position_y - 1]
		if not north_neighbour.is_visited:
			unvisited_neighbours.push_back(north_neighbour)
	
	if current_cell.grid_position_y < maze_grid[current_cell.grid_position_x].size() - 1:
		var south_neighbour = maze_grid[current_cell.grid_position_x][current_cell.grid_position_y + 1]
		if not south_neighbour.is_visited:
			unvisited_neighbours.push_back(south_neighbour)
		
	return unvisited_neighbours


func get_random_neighbour(cell_neighbours: Array) -> Node3D:
	var rng = RandomNumberGenerator.new()
	var neighbour_position = rng.randi_range(0, cell_neighbours.size() - 1)
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


func center_maze_on_screen(maze_width: int, maze_height: int, maze_wall_length: int):
	var maze_position_x = (((maze_width * maze_wall_length) / 2) - 1)
	var maze_position_z = (((maze_height * maze_wall_length) / 2) - 1)
	
	self.set_position(Vector3(-maze_position_x, 0, -maze_position_z))
