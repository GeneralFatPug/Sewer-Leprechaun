extends Node2D

var _water_body
var velocity = 0

var force = 0

var height = 0

var target_height = 0

@onready var collision = $Area2D/CollisionShape2D
@onready var area_2d = $Area2D


func water_update(spring_constant, dampening):
	
	height = position.y 
	
	var x = height - target_height
	
	var loss = -dampening * velocity
	
	force = -spring_constant * x + loss
	
	velocity += force
	
	position.y += velocity
	pass







func initialize(x_position):
	height= position.y
	target_height = position.y
	velocity= 0
	position.x = x_position
	#index = id

func check_water_collision():
	return _water_body

func _on_area_2d_body_entered(body):
	_water_body = body
