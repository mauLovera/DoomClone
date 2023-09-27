extends Node3D

@onready var global_variables = get_node("/root/GlobalVariables")

func _process(delta):
	if global_variables.alive_enemy_count < 6:
		
		
