extends Node

@export var maze_generation_algorithms : Array[PackedScene]

@onready var camera : Camera3D = $"Camera Origin/SpringArm3D/Camera"

var maze_generator: MazeGenerator
var selected_algorithm: PackedScene


func _ready() -> void:
	selected_algorithm = maze_generation_algorithms[0]


func change_algorithm(index: int) -> void:
	selected_algorithm = maze_generation_algorithms[index]


func generate_maze(maze: Maze, is_generated_slowly: bool) -> void:
	var time_start: int = Time.get_ticks_msec()
	
	if maze_generator != null:
		maze_generator.queue_free()
		await maze_generator.tree_exited
	
	maze_generator = selected_algorithm.instantiate()
	maze_generator.name = "Maze Generator"
	self.add_child(maze_generator)
	await maze_generator.generate_maze(maze, is_generated_slowly)
	
	var time_now: int = Time.get_ticks_msec()
	var time_elapsed: int = time_now - time_start
	print(str("Generation Time: ", time_elapsed, "ms"))
