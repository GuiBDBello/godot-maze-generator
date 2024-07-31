extends Node3D

@onready var wall_north: MeshInstance3D = $"Wall North"
@onready var wall_south: MeshInstance3D = $"Wall South"
@onready var wall_east: MeshInstance3D = $"Wall East"
@onready var wall_west: MeshInstance3D = $"Wall West"

var grid_position_x : int
var grid_position_y : int
var is_visited : bool = false


func visit() -> void:
	is_visited = true
