extends Node3D


const MAZE_CELL = preload("res://scenes/maze_cell.tscn")

var maze_grid = []
var generated_slowly = false

@export var maze_width = 2
@export var maze_depth = 2


func generate(maze_width, maze_depth, generated_slowly):
	self.maze_width = maze_width if maze_width is int and maze_width > 0 else self.maze_width
	self.maze_depth = maze_depth if maze_depth is int and maze_depth > 0 else self.maze_depth
	self.generated_slowly = generated_slowly if generated_slowly is bool else self.generated_slowly
	
	for x in maze_width:
		maze_grid.append([])
		for z in maze_depth:
			var maze_cell = MAZE_CELL.instantiate()
			maze_cell.name = str("Maze Cell ", x, "-", z)
			maze_cell.position = Vector3(x, 0, z)
			maze_grid[x].append(maze_cell)
			self.add_child(maze_cell)
	
	await generate_maze(null, maze_grid[0][0])


func generate_maze(previous_cell, current_cell):
	current_cell.visit()
	clear_walls(previous_cell, current_cell)
	
	if generated_slowly:
		await get_tree().create_timer(0.05).timeout
	
	var next_cell = get_next_unvisited_cell(current_cell)
	while next_cell != null:
		await generate_maze(current_cell, next_cell)
		if next_cell != null:
			next_cell = get_next_unvisited_cell(current_cell)


func clear_walls(previous_cell, current_cell):
	if previous_cell == null:
		return
		
	if previous_cell.position.x < current_cell.position.x:
		previous_cell.clear_right_wall()
		current_cell.clear_left_wall()
		return
	
	if previous_cell.position.x > current_cell.position.x:
		previous_cell.clear_left_wall()
		current_cell.clear_right_wall()
		return
	
	if previous_cell.position.z < current_cell.position.z:
		previous_cell.clear_front_wall()
		current_cell.clear_back_wall()
		return
	
	if previous_cell.position.z > current_cell.position.z:
		previous_cell.clear_back_wall()
		current_cell.clear_front_wall()
		return


func get_next_unvisited_cell(current_cell):
	var unvisited_cells = get_unvisited_cells(current_cell)
	unvisited_cells.shuffle()
	
	return null if unvisited_cells.is_empty() else unvisited_cells[0]


func get_unvisited_cells(current_cell):
	var unvisited_cells = []
	var x = current_cell.position.x
	var z = current_cell.position.z
	
	if x + 1 < maze_width:
		var cell_to_right = maze_grid[x + 1][z]
		if cell_to_right.is_visited == false:
			unvisited_cells.append(cell_to_right)
	
	if x - 1 >= 0:
		var cell_to_left = maze_grid[x - 1][z]
		if cell_to_left.is_visited == false:
			unvisited_cells.append(cell_to_left)
	
	if z + 1 < maze_depth:
		var cell_to_front = maze_grid[x][z + 1]
		if cell_to_front.is_visited == false:
			unvisited_cells.append(cell_to_front)
	
	if z - 1 >= 0:
		var cell_to_back = maze_grid[x][z - 1]
		if cell_to_back.is_visited == false:
			unvisited_cells.append(cell_to_back)
	
	return unvisited_cells


func set_maze_width(maze_width):
	self.maze_width = maze_width


func set_maze_depth(maze_depth):
	self.maze_depth = maze_depth


func set_is_generated_slowly(generated_slowly):
	self.generated_slowly = generated_slowly
