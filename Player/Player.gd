extends CharacterBody2D

@onready var tile_map = $"../TileMap"
@onready var sprite = $Sprite2D
var tile_size = 32
var count_of_bombs : int
var count_of_drops : int
@onready var game_over_screen = get_parent().get_parent().get_node("GameOverScreen")
@onready var win_screen = get_parent().get_parent().get_node("WinScreen")
@onready var game_over_screen_button = get_parent().get_parent().get_node("GameOverScreen/Button")
@onready var win_screen_button = get_parent().get_parent().get_node("WinScreen/Button")
@onready var drop_counter_UI = get_parent().get_parent().get_node("CountersUI/ColorRect/DropImage/DropsCollected")
@onready var heart1 = get_parent().get_parent().get_node("CountersUI/HeartsBackground/Heart1Empty/Heart1")
@onready var heart2 = get_parent().get_parent().get_node("CountersUI/HeartsBackground/Heart2Empty/Heart2")
@onready var heart3 = get_parent().get_parent().get_node("CountersUI/HeartsBackground/Heart3Empty/Heart3")
@onready var hearts_background = get_parent().get_parent().get_node("CountersUI/HeartsBackground")

var is_moving = false
func _ready():
	get_node("AnimatedSprite2D").play("Idle")
	
func _physics_process(delta):
	if is_moving == false:
		return
		
	if global_position == sprite.global_position:
		is_moving = false
		return
		
	sprite.global_position = sprite.global_position.move_toward(global_position, 6)

func _process(delta):
	if is_moving:
		return
	
	
	if Input.is_action_pressed("ui_right"):
		move(Vector2.RIGHT)
	elif Input.is_action_pressed("ui_up"):
		move(Vector2.UP)
	elif Input.is_action_pressed("ui_down"):
		move(Vector2.DOWN)
	elif Input.is_action_pressed("ui_left"):
		move(Vector2.LEFT)
	
	
	
func move(direction:Vector2):
	#current tile 
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	
	#target tile
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
		)
	var  tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	
	if tile_data.get_custom_data("walkable")==false:
		return
	
		
	#move player
	is_moving = true
	global_position = tile_map.map_to_local(target_tile)
	
	sprite.global_position = tile_map.map_to_local(current_tile)


func handle_collision(entered_group:String):
	print("PLAYER INTERACTION")
	if entered_group == "BOMB":
		count_of_bombs += 1
		$Gulp.playing = true
		print("count of bombs:  ", count_of_bombs)
		if count_of_bombs == 1:
			heart3.visible = false
		if count_of_bombs == 2:
			heart2.visible = false
		if count_of_bombs == 3:
			handle_game_over()
	if entered_group == "WATERDROP":
		count_of_drops += 1
		drop_counter_UI.text = str(count_of_drops)
		$Gulp.playing = true
		print("count of water drops:  ", count_of_drops)
		if count_of_drops == 25:
			get_tree().paused = true
			win_screen.visible = true
			get_parent().get_parent().get_node("Water_Body").visible = false
		

func handle_game_over():
	hearts_background.visible = false
	get_tree().paused = true
	game_over_screen.visible = true
	get_parent().get_parent().get_node("Water_Body").visible = false

func _on_button_button_down():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_game_over_button_button_down():
	get_tree().paused = false
	get_tree().reload_current_scene()
