extends Node2D

@export var k = 0.015
@export var d = 0.03
@export var spread = 0.0002

var springs = []
var passes = 8

@export var distance_between_springs = 32
@export var spring_number = 16

var water_length = distance_between_springs * spring_number

@onready var water_spring = preload("res://water.tscn")
@onready var _player = get_parent().get_node("world/Player")

@export var depth = 1000
var target_height = global_position.y
var bottom = target_height + depth
var timer = Timer.new()
var rng = RandomNumberGenerator.new()


@onready var water_polygon = $Water_Polygon

func _ready():
	for i in range(spring_number):
		var x_position = distance_between_springs * i
		var w = water_spring.instantiate()
		
		add_child(w)
		springs.append(w)
		w.initialize(x_position)
		#w.set_collision_width(distance_between_springs)
		#w.connect("splash", self, "splash")
	
	timer.set_wait_time(1.0)
	timer.set_one_shot(false)
	#timer.connect("timeout",self,"repeat_me")
	
	
	

func _physics_process(delta):
	
	for i in springs:
		i.water_update(k,d)
		
		if i.check_water_collision() != null:
			if i.check_water_collision() == get_parent().get_node("world/Player"):
				_player.handle_game_over()
		else:
			pass
	var left_deltas = []
	var right_deltas = []
	
	for i in range(springs.size()):
		left_deltas.append(0)
		right_deltas.append(0)
		pass
		
	for j in range(passes):
	
		for i in range(springs.size()):
			if i>0:
				left_deltas[i] = spread * (springs[i].height - springs[i-1].height)
				springs[i-1].velocity += left_deltas[i]
			if i < springs.size()-1:
				right_deltas[i] = spread * (springs[i].height - springs[i+1].height)
				springs[i+1].velocity += right_deltas[i]
	draw_water_body()
func draw_water_body():
		
	var surface_points = []
		
	for i in range(springs.size()):
		surface_points.append(springs[i].position)
			
	var first_index = 0
	var last_index = surface_points.size()-1
	
	var water_polygon_points = surface_points
	
	water_polygon_points.append(Vector2(surface_points[last_index].x, bottom))
	water_polygon_points.append(Vector2(surface_points[first_index].x, bottom))
	
	water_polygon_points = PackedVector2Array(water_polygon_points)
	
	water_polygon.set_polygon(water_polygon_points)
	pass


func splash(index,speed):
	if index>= 0 and index < springs.size():
		springs[index].velocity += speed
		
	pass	
	
	
		


func _on_timer_timeout():
	var my_random_number = rng.randf_range(0.0, 6.0)
	var my_index =  rng.randf_range(0.0, 36.0)
	splash(my_index,my_random_number)
	splash(12,rng.randf_range(0.0, 6.0))
	splash(16, rng.randf_range(0.0, 6.0))
	splash(20, rng.randf_range(0.0, 6.0))
	splash(24, rng.randf_range(0.0, 6.0))
	splash(32, rng.randf_range(0.0, 6.0))
	splash(35, rng.randf_range(0.0, 6.0))
	global_position.y-=20
	pass # Replace with function body.
