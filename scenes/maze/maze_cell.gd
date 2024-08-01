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


func set_wall_sizes(wall_length: int, wall_height: int, wall_thickness: float) -> void:
	set_wall_length(wall_length)
	set_wall_height(wall_height)
	set_wall_thickness(wall_thickness)


func set_wall_length(wall_length: int) -> void:
	self.wall_north.scale.x = wall_length
	self.wall_south.scale.x = wall_length
	self.wall_east.scale.x = wall_length
	self.wall_west.scale.x = wall_length
	
	self.wall_north.position.z = -wall_length
	self.wall_south.position.z = wall_length
	self.wall_east.position.x = wall_length
	self.wall_west.position.x = -wall_length


func set_wall_height(wall_height: int) -> void:
	self.wall_north.scale.y = wall_height
	self.wall_south.scale.y = wall_height
	self.wall_east.scale.y = wall_height
	self.wall_west.scale.y = wall_height


func set_wall_thickness(wall_thickness: float) -> void:
	self.wall_north.scale.z = wall_thickness
	self.wall_south.scale.z = wall_thickness
	self.wall_east.scale.z = wall_thickness
	self.wall_west.scale.z = wall_thickness
