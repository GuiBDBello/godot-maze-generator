extends Camera3D


@onready var camera_origin = $"../.."
@onready var spring_arm = $".."

@export var mouse_sensitivity = 0.5


func _input(event):
	if event is InputEventMouseMotion and event.button_mask & 1:
		var x_rotation = deg_to_rad(-event.relative.y * mouse_sensitivity)
		var y_rotation = deg_to_rad(-event.relative.x * mouse_sensitivity)
		
		camera_origin.rotate_object_local(Vector3(1, 0, 0), x_rotation)
		camera_origin.rotate_y(y_rotation)
		
		camera_origin.rotation.x = clamp(camera_origin.rotation.x, deg_to_rad(0), deg_to_rad(75))
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			spring_arm.spring_length -= 0.1 * spring_arm.spring_length if spring_arm.spring_length > 10 else 1
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			spring_arm.spring_length += 0.1 * spring_arm.spring_length if spring_arm.spring_length > 10 else 1
		
		spring_arm.spring_length = clamp(spring_arm.spring_length, 5, 100)
