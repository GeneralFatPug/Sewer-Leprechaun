extends Node2D

@export var waterdrop_scene: PackedScene
@export var bomb_scene: PackedScene
@onready var timer = $WaterdropSpawnTimer
@onready var water_container = $WaterContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	#pass # Replace with function body.
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer.wait_time > 0.5:
		timer.wait_time -= delta * 0.025
	elif timer.wait_time < 0.5:
		timer.wait_time = 0.5


func _on_waterdrop_spawn_timer_timeout():
	var drop
	var rand_num = randi_range(0,1)
	if rand_num == 0:
		drop = waterdrop_scene.instantiate()
		$Drop.playing = true
	elif rand_num == 1:
		drop = bomb_scene.instantiate() 
		$Drop.playing = true
	else:
		print("error: rand num is outside the range")
	
	drop.global_position = Vector2(randf_range(50,1100), -50)
	water_container.add_child(drop)


func _on_button_button_down():
	get_tree().paused = false
	get_node("OpeningScreen").visible = false
