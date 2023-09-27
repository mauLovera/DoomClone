extends CharacterBody3D

@onready var animated_sprite_3d = $AnimatedSprite3D
@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var global_variables = get_node("/root/GlobalVariables")

@export var move_speed = 2.0
@export var attack_range = 2.0

var is_dead = false 

func _physics_process(_delta):
	if is_dead: 
		return
	if player == null:
		return
	
	var direction = player.global_position - global_position
	direction.y = 0.0
	direction = direction.normalized()
	
	velocity = direction * move_speed
	move_and_slide()
	attempt_to_attack_player()
	
func attempt_to_attack_player():
	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player > attack_range:
		return
		
	var eye_line = Vector3.UP * global_variables.camera_position_y
	var raycast_query = PhysicsRayQueryParameters3D.create(global_position + eye_line, player.global_position + eye_line, 1)
	
	var result = get_world_3d().direct_space_state.intersect_ray(raycast_query)
	if result.is_empty():
		player.kill()
	
func kill():
	is_dead = true
	$DeathSound.play()
	animated_sprite_3d.play("death")
	$CollisionShape3D.disabled = true
