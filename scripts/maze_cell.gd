extends Node3D

var is_visited = false

@onready var back_wall = $"Back Wall"
@onready var front_wall = $"Front Wall"
@onready var left_wall = $"Left Wall"
@onready var right_wall = $"Right Wall"


func visit():
	is_visited = true


func clear_back_wall():
	back_wall.queue_free()
	
	
func clear_front_wall():
	front_wall.queue_free()


func clear_left_wall():
	left_wall.queue_free()


func clear_right_wall():
	right_wall.queue_free()
