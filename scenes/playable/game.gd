extends Node

@export var maze_generation_algorithms : Array[PackedScene]

@onready var camera : Camera3D = $"Camera Origin/SpringArm3D/Camera"

var maze_generator: Node3D
var selected_algorithm: PackedScene


func _ready() -> void:
	selected_algorithm = maze_generation_algorithms[0]


func change_algorithm(index: int) -> void:
	selected_algorithm = maze_generation_algorithms[index]


func generate_maze(maze_width: int, maze_height: int, maze_wall_length: int, maze_wall_height: int, maze_wall_thickness: float, is_generated_slowly: bool) -> void:
	var time_start = Time.get_ticks_msec()
	if maze_generator != null:
		maze_generator.queue_free()
		await maze_generator.tree_exited
	
	maze_generator = selected_algorithm.instantiate()
	maze_generator.name = "Maze Generator"
	self.add_child(maze_generator)
	maze_generator.generate_maze(maze_width, maze_height, maze_wall_length, maze_wall_height, maze_wall_thickness, is_generated_slowly)
	var time_now = Time.get_ticks_msec()
	var time_elapsed = time_now - time_start
	print(str("Generation Time: ", time_elapsed, "ms"))
