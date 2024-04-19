extends CharacterBody2D

@onready var tile_map = $"../TileMap"
@onready var sprite = $Sprite2D
var tile_size = 32

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
