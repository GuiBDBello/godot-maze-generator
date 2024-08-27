extends MazeGenerator

var cell_list: Array[Array] = []
var cell_sets: Dictionary = {}


func _ready() -> void:
	rng.randomize()


func generate_maze(maze: Maze, is_generated_slowly: bool) -> void:
	super.center_maze_on_screen(maze)
	
	var maze_grid: Array[Array] = super.generate_grid(maze)
	
	for x: int in maze_grid.size():
		for y: int in maze_grid[x].size():
			var cell: MazeCell = maze_grid[x][y]
			
			var neighbours: Array[MazeCell] = super.find_neighbours(cell, maze_grid)
			for neighbour: MazeCell in neighbours:
				cell_list.append([cell, neighbour])
			
			cell_sets[cell] = cell
	
	cell_list.shuffle()
	
	for cell in cell_list:
		var current_cell: MazeCell = cell[0]
		var neighbour: MazeCell = cell[1]
		
		if self.find_set(current_cell) != self.find_set(neighbour):
			super.remove_walls_between(current_cell, neighbour)
			self.join_cell_sets(current_cell, neighbour)
			
			if is_generated_slowly:
				await get_tree().create_timer(0.05).timeout


func find_set(cell: MazeCell) -> MazeCell:
	if cell_sets[cell] != cell:
		cell_sets[cell] = self.find_set(cell_sets[cell])
	return cell_sets[cell]


func join_cell_sets(cell: MazeCell, neighbour: MazeCell) -> void:
	var cell1: MazeCell = self.find_set(cell)
	var cell2: MazeCell = self.find_set(neighbour)
	if cell1 != cell2:
		cell_sets[cell2] = cell1
