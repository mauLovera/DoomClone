extends Camera3D
@onready var global_variables = get_node("/root/GlobalVariables")

func _ready():
	global_position.y = global_variables.camera_position_y	
