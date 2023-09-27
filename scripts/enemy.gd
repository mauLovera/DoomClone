extends CharacterBody3D

@onready var animated_sprite_3d = $AnimatedSprite3D
@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var global_variables = get_node("/root/GlobalVariables")
@onready var despawn_timer = $DespawnTimer
@onready var respawn_timer = $"../RespawnTimer"
@onready var spawn_timer = $"../SpawnTimer"

@export var move_speed = 2.0
@export var attack_range = 2.0

var is_dead = false 
var is_spawning = true

func _ready():
	animated_sprite_3d.hide()
	spawn_timer.start()

func _physics_process(_delta):
	if animated_sprite_3d.visible: 
		is_spawning = false
	if is_dead or is_spawning: 
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
	if !animated_sprite_3d.visible:
		return
		
	is_dead = true
	$DeathSound.play()
	animated_sprite_3d.play("death")
	$CollisionShape3D.disabled = true
	despawn_timer.start()
	respawn_timer.start()	
	global_variables.alive_enemy_count -= 1

func _on_spawn_timer_timeout():
	animated_sprite_3d.show()
	is_spawning = false

func _on_despawn_timer_timeout():
	queue_free()
	
func _on_respawn_timer_timeout():
	is_spawning = false
