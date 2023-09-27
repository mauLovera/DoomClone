extends CharacterBody3D

@onready var animated_sprite_2d = $UI/GunBase/AnimatedSprite2D
@onready var ray_cast_3d = $RayCast3D
@onready var shoot_sound = $ShootSound
@onready var death_sound = $PlayerDeath

const SPEED = 5.0
const MOUSE_SENSITIVITY = 0.3

var can_shoot = true
var is_dead = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animated_sprite_2d.animation_finished.connect(shoot_animation_is_done)
	$UI/DeathScreen/Panel/Button.button_up.connect(restart)
	
func _input(event):
	if is_dead:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * MOUSE_SENSITIVITY

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		restart()
		
	if is_dead:
		return
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(_delta):
	if is_dead:
		return
		
	var input_direction = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()

func restart():
	get_tree().reload_current_scene()
	
func shoot():
	if !can_shoot:
		return
	can_shoot = false
	animated_sprite_2d.play("shoot")
	shoot_sound.play()
	
	if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().has_method("kill"):
		ray_cast_3d.get_collider().kill()
	
func shoot_animation_is_done():
	can_shoot = true
	
func kill():
	if is_dead:
		return
		
	is_dead = true
	death_sound.play()
	$UI/DeathScreen.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

