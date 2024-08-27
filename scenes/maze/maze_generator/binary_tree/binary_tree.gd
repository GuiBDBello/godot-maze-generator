extends MazeGenerator


func _ready() -> void:
	rng.randomize()


func generate_maze(maze: Maze, is_generated_slowly: bool) -> void:
	super.center_maze_on_screen(maze)
	
	var maze_grid: Array[Array] = super.generate_grid(maze)

	for x: int in range(maze.width):
		for y: int in range(maze.height):
			self.carve_passage(maze_grid, x, y)

			if is_generated_slowly:
				await get_tree().create_timer(0.05).timeout


func carve_passage(maze_grid: Array[Array], x: int, y: int) -> void:
	var directions: Array[String] = []
	if x > 0:
		directions.append("west")
	if y > 0:
		directions.append("north")

	if directions.size() > 0:
		var direction: String = directions[rng.randi_range(0, directions.size() - 1)]

		if direction == "west":
			super.remove_walls_between(maze_grid[x][y], maze_grid[x - 1][y])
		elif direction == "north":
			super.remove_walls_between(maze_grid[x][y], maze_grid[x][y - 1])
