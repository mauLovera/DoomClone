extends Node3D
@onready var animated_sprite_3d = $AnimatedSprite3D
@export var enemy: PackedScene
@onready var portal_timer = $PortalTimer

func _ready():
	portal_timer.start()

func _on_portal_timer_timeout():
	animated_sprite_3d.hide()

func _on_respawn_timer_timeout():	
	var Enemy = enemy.instantiate()
	animated_sprite_3d.show()
	add_child(Enemy)
	Enemy.get_node("AnimatedSprite3D").show()
	portal_timer.start()
